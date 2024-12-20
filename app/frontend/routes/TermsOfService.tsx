import React from 'react'
import { Paragraph, SectionTitle, Subtitle, Title } from '@/components/Typography'

export default function TermsOfService() {
  return (
    <>
      <Title>Terms of Service</Title>

      <Subtitle>LarCity LLC Terms and Conditions</Subtitle>

      <SectionTitle>1. Acceptance of Terms</SectionTitle>

      <Paragraph>
        By engaging with LarCity LLC (&quot;Company&quot;) for any service or product, you agree to be bound by these terms and conditions.
      </Paragraph>

      <SectionTitle>2. Services</SectionTitle>
      <Paragraph>
        <ul style={{ margin: '1em 0 0 2em', listStyleType: 'disc' }}>
          <li>
            <strong>Consulting Services:</strong> The Company will provide consulting services related to [specific areas of expertise,
            e.g., software development, system integration].
          </li>
          <li>
            <strong>Software Integration and Development:</strong> The Company will provide software integration and development services
            tailored to your specific needs.
          </li>
        </ul>
      </Paragraph>

      <SectionTitle>3. Payment</SectionTitle>
      <Paragraph>
        <ul style={{ margin: '1em 0 0 2em', listStyleType: 'disc' }}>
          <li>
            <strong>Fees:</strong> Fees for services will be as outlined in a separate agreement or proposal.
          </li>
          <li>
            <strong>Payment Terms:</strong> Payment is due upon receipt of an invoice unless otherwise specified.
          </li>
          <li>
            <strong>Late Payments:</strong> Late payments may incur a 2.5% interest charge per month.
          </li>
        </ul>
      </Paragraph>

      <SectionTitle>4. Intellectual Property</SectionTitle>
      <Paragraph>
        <ul style={{ margin: '1em 0 0 2em', listStyleType: 'disc' }}>
          <li>
            <strong>Company IP:</strong> All intellectual property rights, including copyrights, patents, and trademarks, developed or used
            by the Company in the performance of services remain the exclusive property of the Company.
          </li>
          <li>
            <strong>Client IP:</strong> The Client retains ownership of all intellectual property rights provided to the Company.
          </li>
        </ul>
      </Paragraph>

      <SectionTitle>5. Limitation of Liability</SectionTitle>
      <Paragraph>
        To the maximum extent permitted by law, the Company shall not be liable for any indirect, incidental, special, consequential, or
        punitive damages, including but not limited to, loss of profits, revenue, or data, arising out of or in connection with the services
        provided.
      </Paragraph>

      <SectionTitle>6. Indemnification</SectionTitle>
      <Paragraph>
        The Client agrees to indemnify and hold harmless the Company, its officers, directors, employees, and agents from and against any
        and all claims, liabilities, damages, losses, costs, and expenses arising out of the Client&apos;s use of the services.
      </Paragraph>

      <SectionTitle>7. Termination</SectionTitle>
      <Paragraph>
        Either party may terminate this agreement with 30 days&apos; written notice. Upon termination a pro-rated end of service invoice
        will be billed to the client and shall be due upon receipt.
      </Paragraph>

      <SectionTitle>8. Governing Law</SectionTitle>
      <Paragraph>This agreement shall be governed by and construed in accordance with the laws of the State of Ohio.</Paragraph>

      <SectionTitle>9. Dispute Resolution</SectionTitle>
      <Paragraph>Any dispute arising out of or in connection with this agreement shall be resolved through mediation.</Paragraph>
    </>
  )
}
