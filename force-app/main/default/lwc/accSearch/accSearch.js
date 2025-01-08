import {LightningElement,wire} from 'lwc';
import getAccounts from "@salesforce/apex/accountDataService.getAccounts";
export default class AccSearch extends LightningElement {
    selectedAccount = '';
    error = undefined;
    options;

    @wire(getAccounts)
    Accounts({error, data}) {
        if (data){
            this.options = data.map(account => {
                return {
                    value: account.Id,
                    label: account.Name
                }
            });
        } else if (error) {
            this.options = undefined;
            this.error = error;
        }
    }

    handleChange (event) {
        this.selectedAccount = event.target.value;

        const searchEvent = new CustomEvent('search', {
            detail:{
                selectedAccId:this.selectedAccount
            }
        });
        this.dispatchEvent(searchEvent);
    }
}