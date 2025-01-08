import {LightningElement, wire} from 'lwc';
import getOpportunities from "@salesforce/apex/opportunityDataService.getOpportunities";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class BetterOpportunity extends LightningElement {
    opportunities;
    selectedOpportunity;
    selectedAccId;
    error = undefined;

    fields = [
        'Name', 'Amount', 'CloseDate', 'Type', 'StageName', 'Probability', 'Description', 'AccountId', 'LastModifiedById'
    ];

    handleSearch(event){
        this.selectedAccId = event.detail.selectedAccId;
    }

    @wire(getOpportunities, {selectedAccId: '$selectedAccId'})
    wiredOpportunities ({data,error}){
        if (data) {
            this.opportunities = data;
        } else if (error) {
            this.error = error;
        }
    }

    selectOpportunity(event) {
        const oppId = event.currentTarget.dataset.id;
        this.selectedOpportunity = this.opportunities.find(opp => opp.Id === oppId);
    }

    handleSubmit() {
        const submit = new ShowToastEvent({
            title: 'Success!',
            message: 'The changes have been successfully saved.',
            variant: 'success'
        });
        this.dispatchEvent(submit);
    }
}