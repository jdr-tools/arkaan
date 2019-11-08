module Arkaan
  module Campaigns
    # Representation of a file, allowing us to retrieve it on AWS by its filename and linked campaign ID.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class File < Arkaan::Campaigns::Document
      include Arkaan::Concerns::MimeTypable

      # @!attribute [rw] filename
      #   @return [String] the name of the file, corresponding to the AWS name.
      field :name, type: String
      # @!attribute [rw] size
      #   @return [Integer] the size of the file in bytes.
      field :size, type: Integer, default: 0

      mime_type ['image/*', 'text/plain']

      validates :name, presence: {message: 'required'}

      validate :name_unicity

      # Checks if the name is unique in the campaign, and if it is not then modifies it.
      # The modifications are the same than in a windows or UNIX system :
      # - if the name exists as it is given, the system adds the suffix "(1)" to it.
      # - if the name with the suffix still exists, the system tries to increment it until an available name is found.
      # - the found name is then afected to the name of the current file.
      def name_unicity
        if !campaign.nil? && !self[:name].nil?
          if exists_in_campaign(self[:name])
            suffix = 1
            while exists_in_campaign(merge_suffix(suffix))
              suffix = suffix + 1
            end
            self[:name] = merge_suffix(suffix)
          end
        end
      end

      # Merges the given suffix with the name correctly.
      # @param suffix [String] the suffix to append between perenthesis at the end of the file name, but before the extension.
      # @return [String] the complete name for the file, with the suffix correctly appended.
      def merge_suffix(suffix)
        return "#{raw_name} (#{suffix}).#{extension}"
      end

      # Checks if the given name already exists for a file in the campaign.
      # @param tmp_name [String] the name to check the existence of in the campaign.
      # @return [Boolean] TRUE if the file exists in the campaign, FALSE otherwise.
      def exists_in_campaign(tmp_name)
        campaign.files.where(name: tmp_name, :id.ne => id).exists?
      end

      # Returns the file name without the extension for the current file.
      # @return [String] the name of the file without the extension.
      def raw_name
        return self[:name].gsub(".#{extension}", '')
      end

      # Returns the extension of the file, without the dot.
      # @return [String] the text representation for this file extension, without the leading dot.
      def extension
        return self[:name].split('.').last
      end
    end
  end
end