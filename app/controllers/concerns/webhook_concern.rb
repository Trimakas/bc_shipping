module WebhookConcern
extend ActiveSupport::Concern
include ApplicationConcern
  attr_reader :hook_ids, :hooks

  def setup_order_webhook
    create_bc_connection
    # Rails.logger.info "\n This is just a test in setup order webhook #{Bigcommerce::System.time} \n"
    @hook_ids = []
    if does_hook_already_exist?
      @hook_ids << hooks[0][:id]
    else  
      order_updated_hook = Bigcommerce::Webhook.create(scope: 'store/order/updated',
                                                      destination: "#{ENV['URL']}/orders_update",
                                                      connection: create_bc_connection)
      @hook_ids << order_updated_hook.id
    end
  end
  
  def does_hook_already_exist? ## need to update this!!!!!!!
    @hooks = Bigcommerce::Webhook.all({connection: create_bc_connection})
    if @hooks.empty?
      false
    else
      @hooks[0][:destination].include?("https://bc-ship-trimakas.c9users.io/orders_update")
    end
  end
  
  def save_webhooks
    current_store.update(webhook_id: hook_ids)
  end

end
