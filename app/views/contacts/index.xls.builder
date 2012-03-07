xml.instruct!
xml.Workbook 'xmlns:x'    => 'urn:schemas-microsoft-com:office:excel',
             'xmlns:ss'   => 'urn:schemas-microsoft-com:office:spreadsheet',
             'xmlns:html' => 'http://www.w3.org/TR/REC-html40',
             'xmlns'      => 'urn:schemas-microsoft-com:office:spreadsheet',
             'xmlns:o'    => 'urn:schemas-microsoft-com:office:office' do
  xml.Worksheet 'ss:Name' => "Sheet1" do
    xml.Table do
      unless @contacts.empty?
        # Header.
        xml.Row do
          columns = %w{job_title name email alt_email phone mobile
                       fax born_on background_info blog linked_in
                       facebook twitter skype date_created date_updated
                       assigned_to access department source do_not_call}
          
          for column in columns
            xml.Cell do
              xml.Data I18n.t(column), 'ss:Type' => 'String'
            end
          end
        end
        
        # Contact rows.
        for c in @contacts
          xml.Row do
            values = [c.title, c.name, c.email, c.alt_email, c.phone, c.mobile,
                      c.fax, c.born_on, c.background_info, c.blog, c.linkedin,
                      c.facebook, c.twitter, c.skype, c.created_at, c.updated_at,
                      c.assignee.try(:name), c.access, c.department, c.source, c.do_not_call]
            
            for value in values
              xml.Cell do
                xml.Data value, 'ss:Type' => "#{value.respond_to?(:abs) ? 'Number' : 'String'}"
              end
            end
          end
        end
      end
    end
  end
end
