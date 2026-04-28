import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { admin } from 'https://esm.sh/firebase-admin@11'

const serviceAccount = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT') || '{}')

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  })
}

serve(async (req) => {
  try {
    const { record } = await req.json()
    
    // Webhook triggered by INSERT on notifications table
    const userId = record.user_id
    const title = record.title
    const body = record.body

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Fetch user's FCM token
    const { data: user, error: userError } = await supabase
      .from('users')
      .select('fcm_token')
      .eq('id', userId)
      .single()

    if (userError || !user?.fcm_token) {
      throw new Error('User FCM token not found')
    }

    const message = {
      notification: {
        title,
        body,
      },
      token: user.fcm_token,
    }

    const response = await admin.messaging().send(message)
    console.log('Successfully sent message:', response)

    return new Response(JSON.stringify({ success: true, messageId: response }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})
