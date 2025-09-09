import { NextResponse } from 'next/server'

export async function GET() {
  try {
    // Check if Botpress is running by making a request to its health endpoint
    const botpressUrl = process.env.BOTPRESS_URL || 'http://botpress:3000'
    
    const response = await fetch(`${botpressUrl}/api/v1/health`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
      // Add timeout to prevent hanging
      signal: AbortSignal.timeout(5000)
    })

    if (response.ok) {
      return NextResponse.json({ 
        status: 'online', 
        message: 'Botpress is running',
        url: botpressUrl 
      })
    } else {
      return NextResponse.json({ 
        status: 'offline', 
        message: 'Botpress is not responding' 
      }, { status: 503 })
    }
  } catch (error) {
    console.error('Error checking Botpress status:', error)
    return NextResponse.json({ 
      status: 'offline', 
      message: 'Unable to connect to Botpress',
      error: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 503 })
  }
}