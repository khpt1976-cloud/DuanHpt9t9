"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Loader2, ExternalLink, Bot, CheckCircle, XCircle } from "lucide-react"
import { useLanguage } from "@/contexts/language-context"

export default function AdminBotPage() {
  const [isLoading, setIsLoading] = useState(true)
  const [botpressStatus, setBotpressStatus] = useState<'online' | 'offline' | 'checking'>('checking')
  const { t, isHydrated } = useLanguage()

  // Check Botpress status
  useEffect(() => {
    const checkBotpressStatus = async () => {
      try {
        const response = await fetch('/api/botpress/status')
        if (response.ok) {
          setBotpressStatus('online')
        } else {
          setBotpressStatus('offline')
        }
      } catch (error) {
        setBotpressStatus('offline')
      } finally {
        setIsLoading(false)
      }
    }

    checkBotpressStatus()
    // Check status every 30 seconds
    const interval = setInterval(checkBotpressStatus, 30000)
    return () => clearInterval(interval)
  }, [])

  const openBotpress = () => {
    // Open Botpress in a new window/tab
    window.open('http://localhost:12001', '_blank', 'width=1200,height=800')
  }

  const openBotpressEmbedded = () => {
    // Open Botpress in an iframe within the current page
    const iframe = document.createElement('iframe')
    iframe.src = 'http://localhost:12001'
    iframe.style.width = '100%'
    iframe.style.height = '600px'
    iframe.style.border = 'none'
    iframe.style.borderRadius = '8px'
    
    const container = document.getElementById('botpress-container')
    if (container) {
      container.innerHTML = ''
      container.appendChild(iframe)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">
          {isHydrated ? t("admin.adminbot.title") : "AdminBot - Quản lý Chatbot"}
        </h1>
        <p className="text-muted-foreground">
          {isHydrated ? t("admin.adminbot.description") : "Quản lý và cấu hình chatbot Botpress cho hệ thống"}
        </p>
      </div>

      {/* Status Card */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Bot className="h-5 w-5" />
            {isHydrated ? t("admin.adminbot.status.title") : "Trạng thái Botpress"}
          </CardTitle>
          <CardDescription>
            {isHydrated ? t("admin.adminbot.status.description") : "Kiểm tra tình trạng hoạt động của Botpress server"}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            {isLoading ? (
              <div className="flex items-center gap-2">
                <Loader2 className="h-4 w-4 animate-spin" />
                <span>{isHydrated ? t("admin.adminbot.status.checking") : "Đang kiểm tra..."}</span>
              </div>
            ) : (
              <div className="flex items-center gap-2">
                {botpressStatus === 'online' ? (
                  <>
                    <CheckCircle className="h-4 w-4 text-green-500" />
                    <Badge variant="default" className="bg-green-500">
                      {isHydrated ? t("admin.adminbot.status.online") : "Trực tuyến"}
                    </Badge>
                  </>
                ) : (
                  <>
                    <XCircle className="h-4 w-4 text-red-500" />
                    <Badge variant="destructive">
                      {isHydrated ? t("admin.adminbot.status.offline") : "Ngoại tuyến"}
                    </Badge>
                  </>
                )}
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Actions Card */}
      <Card>
        <CardHeader>
          <CardTitle>
            {isHydrated ? t("admin.adminbot.actions.title") : "Hành động"}
          </CardTitle>
          <CardDescription>
            {isHydrated ? t("admin.adminbot.actions.description") : "Truy cập và quản lý giao diện Botpress"}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Button 
              onClick={openBotpress}
              disabled={botpressStatus !== 'online'}
              className="flex items-center gap-2"
            >
              <ExternalLink className="h-4 w-4" />
              {isHydrated ? t("admin.adminbot.actions.open_new_tab") : "Mở trong tab mới"}
            </Button>
            
            <Button 
              variant="outline"
              onClick={openBotpressEmbedded}
              disabled={botpressStatus !== 'online'}
              className="flex items-center gap-2"
            >
              <Bot className="h-4 w-4" />
              {isHydrated ? t("admin.adminbot.actions.open_embedded") : "Mở trong trang này"}
            </Button>
          </div>
          
          {botpressStatus === 'offline' && (
            <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
              <p className="text-sm text-yellow-800">
                {isHydrated ? t("admin.adminbot.offline_message") : "Botpress server hiện không khả dụng. Vui lòng kiểm tra lại sau hoặc liên hệ quản trị viên."}
              </p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Embedded Container */}
      <Card>
        <CardHeader>
          <CardTitle>
            {isHydrated ? t("admin.adminbot.embedded.title") : "Giao diện Botpress"}
          </CardTitle>
          <CardDescription>
            {isHydrated ? t("admin.adminbot.embedded.description") : "Giao diện Botpress được nhúng trực tiếp"}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div id="botpress-container" className="min-h-[400px] bg-gray-50 rounded-lg flex items-center justify-center">
            <div className="text-center text-gray-500">
              <Bot className="h-12 w-12 mx-auto mb-4 opacity-50" />
              <p>{isHydrated ? t("admin.adminbot.embedded.placeholder") : "Nhấn 'Mở trong trang này' để hiển thị giao diện Botpress"}</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}