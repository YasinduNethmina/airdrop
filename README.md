# Airdrop Process Instructions

This document outlines the steps required to prepare and execute an airdrop using the airdropBatch function. The process involves handling large number representations and formatting data correctly.

## Steps

### Generate Addresses and Amount Data:

Run the provided script with `npm start` to obtain all the relevant addresses and their respective airdrop amounts. (This might take a couple of minutes depending on the dataset)

This data will be stored in airdrop_data.txt.

### Verify and Correct Amounts:

Open airdrop_data.txt and inspect the amounts listed.

If you find any amounts in scientific notation (e.g., "1.304e+21"), replace these with their full numeric string representations.

### Format Data for Airdrop:

Remove the opening and closing square brackets ([]) from the amounts array in airdrop_data.txt.

Ensure that the data is clean and correctly formatted for the next step.

Prepare for Airdrop Execution:

Copy the list of recipient addresses and the corresponding amounts.

Paste these lists into the recipients and amounts inputs, respectively, in the airdropBatch function in your smart contract.

### Important Notes

Accuracy is Crucial: Ensure all amounts are correctly represented and formatted. Incorrect or misformatted data could lead to failed transactions or unintended airdrop values.

Data Integrity: Double-check the recipient addresses to prevent sending funds to incorrect or invalid addresses.

Testing: It's recommended to perform a test run with a small subset of addresses and amounts to ensure the process works as expected.

By following these instructions, you can efficiently prepare and execute the airdrop while ensuring the integrity and accuracy of the transactions.
