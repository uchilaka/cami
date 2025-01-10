# frozen_string_literal: true

class InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[search]

  include MaybeAccountSpecific

  load_account :all,
               optional: true,
               id_keys: %i[account_id],
               bounce_to: :invoices_path

  load_console

  before_action :set_invoice, only: %i[show edit update destroy]

  # GET /invoices or /invoices.json
  def index
    @query = policy_scope(Invoice).ransack(search_query.predicates)
    @query.sorts = search_query.sorters if search_query.sorters.any?
    @invoices = @query.result(distinct: true)
  end

  def search
    @query = policy_scope(Invoice).ransack(search_query.predicates)
    @query.sorts = search_query.sorters if search_query.sorters.any?
    @invoices = @query.result(distinct: true)
  end

  # GET /invoices/1 or /invoices/1.json
  def show; end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit; end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @invoice.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @invoice.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy!

    respond_to do |format|
      format.html { redirect_to invoices_path, status: :see_other, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def search_query
    @search_query ||= InvoiceSearchQuery.new(params[:q], params:)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = policy_scope(Invoice).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params
      .require(:invoice)
      .permit(
        :account_id,
        :invoice_number,
        :status,
        :issued_at,
        :due_at,
        :amount,
        :due_amount,
        :currency_code,
        :notes
      )
  end
end
