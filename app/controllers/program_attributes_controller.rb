class ProgramAttributesController < ApplicationController
    before_action :set_program_attribute, only: [:save]

    def table_data
        @program = Program.find(params[:program_id])
        @attributes = @program.program_attributes.sort_by(&:id)
        respond_to do |format| 
            format.js
            format.json { render json: { data: @attributes } }
        end
    end

    def save
        if params[:id].present?
            @program_attribute.update!(program_attribute_params)
        else
            @program_attribute.save
        end

        @attributes = ProgramAttribute.all.sort_by(&:id)
        
        render json: { data: @attributes }, status: :ok
    end

    private

    def program_attribute_params
        params.require(:program_attribute).permit(:name, :question, :weight)
    end

    def set_program_attribute
        if params[:id].present?
            @program_attribute = ProgramAttribute.find(params[:id])
        else
            @program = Program.find(params[:program_id])
            @program_attribute = @program.program_attributes.build(program_attribute_params)
        end
    end
end
