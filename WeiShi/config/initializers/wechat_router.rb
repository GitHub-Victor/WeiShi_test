# -*- encoding : utf-8 -*-
module Wechat
  # 微信内部路由规则类，用于简化配置
  class Router

    # 支持以下形式
    # WechatRouter.new(:type=>"text")
    # WechatRouter.new(:type=>"text", :content=>"Hello2BusUser")
    # WechatRouter.new(:type=>"text", :content=>/^@/)
    # WechatRouter.new {|xml| xml[:MsgType] == 'image'}
    # WechatRouter.new(:type=>"text") {|xml| xml[:Content].starts_with? "@"}
    def initialize(options, &block)
      @type = options[:type] if options[:type]
      @content = options[:content] if options[:content]
      @event = options[:event] if options[:event]
      @constraint = block if block_given?
    end

    def matches?(request)
      xml = request.params[:xml]
      result = true
      result = result && (xml[:MsgType] == @type) if @type
      result = result && (xml[:Content] =~ @content) if @content.is_a? Regexp
      result = result && (xml[:Content] == @content) if @content.is_a? String
      result = result && (xml[:Event] == @event) if @event.is_a? String
      result = result && @constraint.call(xml) if @constraint

      return result
    end
  end

  module ActionController
    # 辅助方法，用于简化操作，wechat_xml.content 比用hash舒服多了，对不？
    def wechat_xml
      @wechat_xml ||= WechatXml.new(params[:xml])
      return @wechat_xml
    end

    class WechatXml
      attr_accessor :content, :type, :from_user, :to_user, :pic_url
      def initialize(hash)
        @content = hash[:Content]
        @type = hash[:MsgType]
        @from_user = hash[:FromUserName]
        @to_user = hash[:ToUserName]
        @pic_url = hash[:PicUrl]
      end
    end
  end
end

ActionController::Base.class_eval do
  include ::Wechat::ActionController
end
ActionView::Base.class_eval do
  include ::Wechat::ActionController
end