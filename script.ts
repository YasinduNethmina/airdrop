import fs from "fs";

import { createPublicClient, http, parseEther } from "viem";
import { arbitrum } from "viem/chains";

import { nftCollectionAddress } from "./constants";
import NFT_COLLECTION_ABI from "./constants/nftCollection.json";

const client = createPublicClient({
  chain: arbitrum,
  transport: http(),
});

const getAllAddresses = async (): Promise<string[]> => {
  try {
    const totalSupply = await client.readContract({
      address: nftCollectionAddress,
      abi: NFT_COLLECTION_ABI,
      functionName: "totalSupply",
    });

    let addresses: string[] = [];
    for (let i = 1; i <= Number(totalSupply); i++) {
      const ownerOf = (await client.readContract({
        address: nftCollectionAddress,
        abi: NFT_COLLECTION_ABI,
        functionName: "ownerOf",
        args: [i],
      })) as string;

      addresses.push(ownerOf);
      console.log(addresses.length, "from", Number(totalSupply), ownerOf);
    }
    return addresses;
  } catch (err) {
    throw err;
  }
};

(async () => {
  try {
    const addresses = await getAllAddresses();
    const airdropAmountInWei = Number(parseEther("1"));

    console.log(
      "Processing in progress: Filtering unique addresses and calculating respective amounts. This may take a few moments..."
    );

    const addressAmountMap = new Map();
    addresses &&
      addresses.forEach((address: string) => {
        const normalizedAddress = address.toLowerCase();
        const currentAmount = addressAmountMap.get(normalizedAddress) || 0;
        addressAmountMap.set(
          normalizedAddress,
          currentAmount + airdropAmountInWei
        );
      });

    const uniqueAddresses = Array.from(addressAmountMap.keys());
    const amounts = Array.from(addressAmountMap.values()).map((amount) =>
      amount.toString()
    );

    console.log("Storing data into airdrop_data.txt file...");

    const outputFile = "airdrop_data.txt";
    let fileContent = "Unique Addresses:\n";

    fileContent += JSON.stringify(uniqueAddresses);
    fileContent += "\n\nAmounts:\n";
    fileContent += JSON.stringify(amounts);

    fs.writeFile(outputFile, fileContent, (err) => {
      if (err) throw err;
      console.log(`Data has been written to ${outputFile}`);
    });

    return { uniqueAddresses, amounts };
  } catch (err) {
    console.log(err);
  }
})();
