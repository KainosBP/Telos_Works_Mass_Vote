#!/bin/bash

echo -n "Please enter ballot name: "
read ballot_name
echo -n "Please enter your vote (yes or no): "
read options

while IFS= read -r account_name; do
    echo "Processing account: ${account_name}"
    cleos -u https://mainnet.telos.net push transaction "{
        \"delay_sec\": 0,
        \"max_cpu_usage_ms\": 0,
        \"actions\": [
            {
                \"account\": \"telos.decide\",
                \"name\": \"refresh\",
                \"data\": {
                    \"voter\": \"${account_name}\"
                },
                \"authorization\": [
                    {
                        \"actor\": \"${account_name}\",
                        \"permission\": \"active\"
                    }
                ]
            },
            {
                \"account\": \"telos.decide\",
                \"name\": \"castvote\",
                \"data\": {
                    \"voter\": \"${account_name}\",
                    \"ballot_name\": \"${ballot_name}\",
                    \"options\": [
                        \"${options}\"
                    ]
                },
                \"authorization\": [
                    {
                        \"actor\": \"${account_name}\",
                        \"permission\": \"active\"
                    }
                ]
            }
        ]
    }"
done < accounts.txt
