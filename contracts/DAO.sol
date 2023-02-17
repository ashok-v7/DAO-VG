// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract DAO is ReentrancyGuard,AccessControl{

// variables
bytes32 private immutable  CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR");
bytes32 private immutable  STAKEHOLDER_ROLE = keccak256("STAKEHOLDER");

uint256 immutable MIN_STAKEHOLDER_CONTRIBUTION = 1 ether;
uint32  immutable MIN_VOTE_DURATION = 3 minutes;
uint32 totalProposals ;
uint256 daoBalance;


//   now mappings
mapping(uint256 => ProposalStruct) private raisedProposals;
mapping(address => uint256[]) private stakeholderVotes;
mapping(uint256 => VotedStruct[]) private votedOn;
mapping(address => uint256) private contributors;
mapping(address => uint256) private stakeholders;


//now define  STRUCT for ProposalStruct

struct ProposalStruct {
uint256 id;
uint256 amount;
uint256 duration;
uint256 upvotes;
uint256 downvotes;
string tittle;
string description;
bool passed;
bool paid;
address payable beneficiary;
address proposer;
address executor;
}

struct VotedStruct{
address voter ;
uint256 timestamp;
bool choosen;

}

// event to keep track 
event Action(
address indexed initiator,
bytes32 role, // contributor , proposal
string message,
address indexed beneficiary,
uint256 amount
);

// modifier 

modifier stakeholderOnly(string memory message){
require(hasRole(STAKEHOLDER_ROLE,msg.sender),message);
_;
}
modifier contributorOnly(string memory message) {
require(hasRole(CONTRIBUTOR_ROLE, msg.sender), message);
_;
}

function createProposal(string memory title,string memory description,address beneficiary,
uint256 amount ) external stakeholderOnly ("Proposal Creation Allowed for Stakeholders only")

{

uint32 proposalId = totalProposals++;
ProposalStruct storage proposal = raiseProposals[propoalId];

proposal.id = proposalId;
proposal.proposer = payable(msg.sender);
proposla.title = title;
proposal.description = description;
proposal.beneficiary =payable(beneficiary);
proposal.amount = amount;
proposal.duration = block.timstamp+MIN_VOTE_DURATION;

emit Action(
msg.sender,
CONTRIBUTOR_ROLE,
"PROPOSAL RAISED",
beneficiary,
amount
);

return VotedStruct(
msg.sender,
block.timestamp,
chosen
);


// call function to pass 
function payTo(
address to, 
uint256 amount
) internal returns (bool) {
(bool success,) = payable(to).call{value: amount}("");
require(success, "Payment failed");
return true;
}


function payBeneficiary(uint256 proposalId) external stakeholderOnly("Unauthorized: Stakeholders only") nonReentrant()
returns (uint256)

{

ProposalStruct storage proposal = raisedProposals[proposalId];
require(daoBalance >= proposal.amount,"Insufficient fund");
if (proposal.paid) revert("payment sent before")
if (proposal.upvotes <= proposal.downvotes) revert("Insufficient votes")

proposal.paid= True;
proposal.executor = msg.sender;
daoBalance -= proposal.amount;

payTo(proposal.beneficiary, proposal.amount);  // this line is placed here to prevent reentracncy


emit Action(
msg.sender,
STAKEHOLDER_ROLE,
"PAYMENT TRANSFERED",
proposal.beneficiary,
proposal.amount
);

return daoBalance;

}



function contribute() payable external returns (uint256) {
require(msg.value > 0 ether, "Contributing zero is not allowed.");
if (!hasRole(STAKEHOLDER_ROLE, msg.sender)) {
    uint256 totalContribution = contributors[msg.sender] + msg.value;

if (totalContribution >= MIN_STAKEHOLDER_CONTRIBUTION) {
stakeholders[msg.sender] = totalContribution;
// contributors[msg.sender] += msg.value;
_grantRole(STAKEHOLDER_ROLE, msg.sender);
//     _grantRole(CONTRIBUTOR_ROLE, msg.sender);
} 

contributors[msg.sender] += msg.value;
_grantRole(CONTRIBUTOR_ROLE, msg.sender);

}
else {
contributors[msg.sender] += msg.value;
stakeholders[msg.sender] += msg.value;

}
}
daoBalance+= msg.value;
}




}


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract DAO is ReentrancyGuard,AccessControl{

// variables
bytes32 private immutable  CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR");
bytes32 private immutable  STAKEHOLDER_ROLE = keccak256("STAKEHOLDER");

uint256 immutable MIN_STAKEHOLDER_CONTRIBUTION = 1 ether;
uint32  immutable MIN_VOTE_DURATION = 3 minutes;
uint32 totalProposals ;
uint256 daoBalance;


//   now mappings
mapping(uint256 => ProposalStruct) private raisedProposals;
mapping(address => uint256[]) private stakeholderVotes;
mapping(uint256 => VotedStruct[]) private votedOn;
mapping(address => uint256) private contributors;
mapping(address => uint256) private stakeholders;


//now define  STRUCT for ProposalStruct

struct ProposalStruct {
uint256 id;
uint256 amount;
uint256 duration;
uint256 upvotes;
uint256 downvotes;
string tittle;
string description;
bool passed;
bool paid;
address payable beneficiary;
address proposer;
address executor;
}

struct VotedStruct{
address voter ;
uint256 timestamp;
bool choosen;

}

// event to keep track 
event Action(
address indexed initiator,
bytes32 role, // contributor , proposal
string message,
address indexed beneficiary,
uint256 amount
);

// modifier 

modifier stakeholderOnly(string memory message){
require(hasRole(STAKEHOLDER_ROLE,msg.sender),message);
_;
}
modifier contributorOnly(string memory message) {
require(hasRole(CONTRIBUTOR_ROLE, msg.sender), message);
_;
}

function createProposal(
string memory title,
string memory description,
address beneficiary,
uint256 amount ) external stakeholderOnly ("Proposal Creation Allowed for Stakeholders only")

{

uint32 proposalId = totalProposals++;
ProposalStruct storage proposal = raiseProposals[propoalId];

proposal.id = proposalId;
proposal.proposer = payable(msg.sender);
proposla.title = title;
proposal.description = description;
proposal.beneficiary =payable(beneficiary);
proposal.amount = amount;
proposal.duration = block.timstamp+MIN_VOTE_DURATION;

emit Action(
msg.sender,
CONTRIBUTOR_ROLE,
"PROPOSAL RAISED",
beneficiary,
amount
);

return VotedStruct(
msg.sender,
block.timestamp,
chosen
);


// call function to pass 
function payTo(
address to, 
uint256 amount
) internal returns (bool) {
(bool success,) = payable(to).call{value: amount}("");
require(success, "Payment failed");
return true;
}


function payBeneficiary(uint256 proposalId) external stakeholderOnly("Unauthorized: Stakeholders only") nonReentrant()
returns (uint256)

{

ProposalStruct storage proposal = raisedProposals[proposalId];
require(daoBalance >= proposal.amount,"Insufficient fund");
if (proposal.paid) revert("payment sent before")
if (proposal.upvotes <= proposal.downvotes) revert("Insufficient votes")

proposal.paid= True;
proposal.executor = msg.sender;
daoBalance -= proposal.amount;

payTo(proposal.beneficiary, proposal.amount);  // this line is placed here to prevent reentracncy


emit Action(
msg.sender,
STAKEHOLDER_ROLE,
"PAYMENT TRANSFERED",
proposal.beneficiary,
proposal.amount
);

return daoBalance;

}


function contribute() payable external returns (uint256) {
require(msg.value > 0 ether, "Contributing zero is not allowed.");
    if (!hasRole(STAKEHOLDER_ROLE, msg.sender)) {
uint256 totalContribution =
    contributors[msg.sender] + msg.value;

        if (totalContribution >= MIN_STAKEHOLDER_CONTRIBUTION) {
    stakeholders[msg.sender] = totalContribution;
    contributors[msg.sender] += msg.value;
    _setupRole(STAKEHOLDER_ROLE, msg.sender);
    _setupRole(CONTRIBUTOR_ROLE, msg.sender);
} else {
    contributors[msg.sender] += msg.value;
    _setupRole(CONTRIBUTOR_ROLE, msg.sender);
}
} else {
contributors[msg.sender] += msg.value;
stakeholders[msg.sender] += msg.value;
}






    }




}



}




}// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract DAO is ReentrancyGuard,AccessControl{

// variables
bytes32 private immutable  CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR");
bytes32 private immutable  STAKEHOLDER_ROLE = keccak256("STAKEHOLDER");

uint256 immutable MIN_STAKEHOLDER_CONTRIBUTION = 1 ether;
uint32  immutable MIN_VOTE_DURATION = 3 minutes;
uint32 totalProposals ;
uint256 daoBalance;


//   now mappings
mapping(uint256 => ProposalStruct) private raisedProposals;
mapping(address => uint256[]) private stakeholderVotes;
mapping(uint256 => VotedStruct[]) private votedOn;
mapping(address => uint256) private contributors;
mapping(address => uint256) private stakeholders;


//now define  STRUCT for ProposalStruct

struct ProposalStruct {
uint256 id;
uint256 amount;
uint256 duration;
uint256 upvotes;
uint256 downvotes;
string tittle;
string description;
bool passed;
bool paid;
address payable beneficiary;
address proposer;
address executor;
}

struct VotedStruct{
address voter ;
uint256 timestamp;
bool choosen;

}

// event to keep track 
event Action(
address indexed initiator,
bytes32 role, // contributor , proposal
string message,
address indexed beneficiary,
uint256 amount
);

// modifier 

modifier stakeholderOnly(string memory message){
require(hasRole(STAKEHOLDER_ROLE,msg.sender),message);
_;
}
modifier contributorOnly(string memory message) {
require(hasRole(CONTRIBUTOR_ROLE, msg.sender), message);
_;
}

function createProposal(
string memory title,
string memory description,
address beneficiary,
uint256 amount ) external stakeholderOnly ("Proposal Creation Allowed for Stakeholders only")

{

uint32 proposalId = totalProposals++;
ProposalStruct storage proposal = raiseProposals[propoalId];

proposal.id = proposalId;
proposal.proposer = payable(msg.sender);
proposla.title = title;
proposal.description = description;
proposal.beneficiary =payable(beneficiary);
proposal.amount = amount;
proposal.duration = block.timstamp+MIN_VOTE_DURATION;

emit Action(
msg.sender,
CONTRIBUTOR_ROLE,
"PROPOSAL RAISED",
beneficiary,
amount
);

return VotedStruct(
msg.sender,
block.timestamp,
chosen
);


// call function to pass 
function payTo(
address to, 
uint256 amount
) internal returns (bool) {
(bool success,) = payable(to).call{value: amount}("");
require(success, "Payment failed");
return true;
}


function payBeneficiary(uint256 proposalId) external stakeholderOnly("Unauthorized: Stakeholders only") nonReentrant()
returns (uint256)

{

ProposalStruct storage proposal = raisedProposals[proposalId];
require(daoBalance >= proposal.amount,"Insufficient fund");
if (proposal.paid) revert("payment sent before")
if (proposal.upvotes <= proposal.downvotes) revert("Insufficient votes")

proposal.paid= True;
proposal.executor = msg.sender;
daoBalance -= proposal.amount;

payTo(proposal.beneficiary, proposal.amount);  // this line is placed here to prevent reentracncy


emit Action(
msg.sender,
STAKEHOLDER_ROLE,
"PAYMENT TRANSFERED",
proposal.beneficiary,
proposal.amount
);

return daoBalance;

}


function contribute() payable external returns (uint256) {
require(msg.value > 0 ether, "Contributing zero is not allowed.");
    if (!hasRole(STAKEHOLDER_ROLE, msg.sender)) {
uint256 totalContribution =
    contributors[msg.sender] + msg.value;

        if (totalContribution >= MIN_STAKEHOLDER_CONTRIBUTION) {
    stakeholders[msg.sender] = totalContribution;
    contributors[msg.sender] += msg.value;
    _setupRole(STAKEHOLDER_ROLE, msg.sender);
    _setupRole(CONTRIBUTOR_ROLE, msg.sender);
} else {
    contributors[msg.sender] += msg.value;
    _setupRole(CONTRIBUTOR_ROLE, msg.sender);
}
} else {
contributors[msg.sender] += msg.value;
stakeholders[msg.sender] += msg.value;
}

daoBalance += msg.value;

emit Action(
msg.sender,
STAKEHOLDER_ROLE,
"CONTRIBUTION RECEIVED",
address(this),
msg.value
);

function getProposals()external view returns (ProposalStruct[] memory props)
{
props = new ProposalStruct[](totalProposals); 
for (uint256 i = 0; i < totalProposals; i++) {
    props[i] = raisedProposals[i];
}
}

function getProposal(uint256 proposalId)   external view returns (ProposalStruct memory)
{
    return raisedProposals[proposalId];
}

    function getVotesOf(uint256 proposalId) external view returns (VotedStruct[] memory)
{
    return votedOn[proposalId];
}

function getStakeholderVotes() external view stakeholderOnly("Unauthorized: not a stakeholder") returns (uint256[] memory)
{
    return stakeholderVotes[msg.sender];
}

    function getStakeholderBalance()external view stakeholderOnly("Unauthorized: not a stakeholder") returns (uint256)
{
    return stakeholders[msg.sender];
}


}
}    

















