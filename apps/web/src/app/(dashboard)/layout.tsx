'use client';

import { Footer } from '@/components/layout/footer';
import { Header } from '@/components/layout/header';
import { Sidebar } from '@/components/layout/sidebar';
import { AgentPhonePanel, PhoneProvider } from '@/components/phone';

export default function DashboardLayout({ children }: { children: React.ReactNode }): JSX.Element {
  return (
    <PhoneProvider>
      <div className="flex h-screen overflow-hidden">
        <Sidebar />
        <div className="flex flex-1 flex-col overflow-hidden">
          <Header />
          <main className="flex-1 overflow-auto bg-background p-6">
            <div className="h-full overflow-auto">{children}</div>
          </main>
          <Footer />
        </div>

        {/* Agent Phone Panel - Floating softphone */}
        <AgentPhonePanel />
      </div>
    </PhoneProvider>
  );
}
