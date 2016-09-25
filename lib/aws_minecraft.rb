require 'aws_minecraft/aws_helper'
require 'aws_minecraft/db_helper'
require 'aws_minecraft/mine_config'
require 'net/ssh'
require 'logger'

module AWSMine
  # Main class for AWS Minecraft
  class AWSMine
    def initialize
      @aws_helper = AWSHelper.new
      @db_helper = DBHelper.new
      @logger = Logger.new(STDOUT)
      @logger.level = Logger.const_get(MineConfig.new.loglevel)
    end

    def start_instance
      if @db_helper.instance_exists?
        ip, id = @db.instance_details
        @logger.info 'Instance already exists.'
        state = @aws_helper.state(id)
        @logger.info "State is: #{state}"
        @logger.info "Public ip | id: #{ip} | #{id}"
        raise
      end
      ip, id = @aws_helper.create_ec2('1.9')
      @db_helper.store_instance(ip, id)
    end

    def init_db
      @logger.info 'Creating db.'
      @db_helper.init_db
      @logger.info 'Done.'
    end

    def remote_exec(cmd)
      ip, = @db.instance_details
      @aws_helper.remote_exec(ip, cmd)
    end
  end
end
