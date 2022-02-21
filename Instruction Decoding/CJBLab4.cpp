// Bradley, Cody CS516 Section 11107 11/26/19
// Lab 4 - Instruction Decoding

#include<iostream>
#include<string>
#include<sstream>
#include<iomanip>
using namespace std;

void getTable();//function used to take the table and turn it into struct entries with correct syntax
string strToUpper(string original);
bool validateHex(string userHex);//checks if the user's input is valid for this program's purposes
int findOpCode(string userHex);//compares the first two characters in the string to the opcodes in the codeTable
//findOpCode returns the index of the opCode in the table, or -1 if it is not found
int hexToInt(string hexString);//helper function used in process functions, returns int equivalent of given hex string
void processRR(string hexInst, int codeIndex);
void processRX(string hexInst, int codeIndex);

struct  opCodeEntry{
	string mnem;//mnemonic for the opcode
	string name;//full name of the opcode
	string format;//format for the opcode
	string opCode;//hex value for the opcode
	void(*fncPtr)(string hexInst, int codeIndex);//function pointer to either point to RR or RX function
};

typedef opCodeEntry opce;

const opce CODETABLE[] = {
	{ "AR", "Add", "RR", "1A", processRR },
	{ "BALR", "Branch and Link", "RR", "05", processRR },
	{ "BCR", "Branch on Condition", "RR", "07", processRR },
	{ "BCTR", "Branch on Count", "RR", "06", processRR },
	{ "CR", "Compare", "RR", "19", processRR },
	{ "DR", "Divide", "RR", "1D", processRR },
	{ "LCR", "Load Complement", "RR", "13", processRR },
	{ "LNR", "Load Negative", "RR", "11", processRR },
	{ "LPR", "Load Positive", "RR", "10", processRR },
	{ "LR", "Load", "RR", "18", processRR },
	{ "LTR", "Load and Test", "RR", "12", processRR },
	{ "MR", "Multiply", "RR", "1C", processRR },
	{ "NR", "AND", "RR", "14", processRR },
	{ "OR", "OR", "RR", "16", processRR },
	{ "SR", "Subtract", "RR", "1B", processRR },
	{ "XR", "Exclusive OR", "RR", "17", processRR },
	{ "A", "Add", "RX", "5A", processRX },
	{ "AH", "Add Halfword", "RX", "4A", processRX },
	{ "AL", "Add Logical", "RX", "5E", processRX },
	{ "BAL", "Branch and Link", "RX", "45", processRX },
	{ "BC", "Branch on Condition", "RX", "47", processRX },
	{ "BCT", "Branch on Count", "RX", "46", processRX },
	{ "C", "Compare", "RX", "59", processRX },
	{ "CH", "Compare Halfword", "RX", "49", processRX },
	{ "CL", "Compare Logical", "RX", "55", processRX },
	{ "CVB", "Convert to Binary", "RX", "4F", processRX },
	{ "CVD", "Convert to Decimal", "RX", "4E", processRX },
	{ "D", "Divide", "RX", "5D", processRX },
	{ "EX", "Execute", "RX", "44", processRX },
	{ "IC", "Insert Character", "RX", "43", processRX },
	{ "L", "Load", "RX", "58", processRX },
	{ "LA", "Load Address", "RX", "41", processRX },
	{ "LH", "Load Halfword", "RX", "48", processRX },
	{ "M", "Multiply", "RX", "5C", processRX },
	{ "MH", "Multiply Halfword", "RX", "4C", processRX },
	{ "N", "AND", "RX", "54", processRX },
	{ "O", "OR", "RX", "56", processRX },
	{ "S", "Subtract", "RX", "5B", processRX },
	{ "SH", "Subtract Halfword", "RX", "4B", processRX },
	{ "SL", "Subtract Logical", "RX", "5F", processRX },
	{ "ST", "Store", "RX", "50", processRX },
	{ "STC", "Store Character", "RX", "42", processRX },
	{ "STH", "Store Halfword", "RX", "40", processRX },
	{ "X", "Exclusive OR", "RX", "57", processRX },
};

const int TOTALENTRIES = 44;//number of entries in codeTable

int main() {
	string userHex, choice;
	bool validHex = false, validChoice = false;
	int opCodeIndex = -1;
	cout << "Pierce College CS516 Fall 2019 Lab Assignment 4 - Bradley, Cody\n" << endl;
	do {
		do {
			cout << "\nEnter the machine instruction in hexadecimal -- must be four, eight, or twelve digits only." << endl;
			cin >> userHex;
			userHex = strToUpper(userHex);//easier to handle if everything is uppercase
			validHex = validateHex(userHex);
			if (validHex)
				opCodeIndex = findOpCode(userHex);
		} while (!validHex || opCodeIndex == -1);//exits loop on valid hex and index != -1

		if ((userHex.length() != 4 && CODETABLE[opCodeIndex].format == "RR") ||
			(userHex.length() != 8 && CODETABLE[opCodeIndex].format == "RX"))
			cout << "\nLength of input does not agree with operation code format -- output may be inaccurate" << endl;
		CODETABLE[opCodeIndex].fncPtr(userHex, opCodeIndex);
		do {
			cout << "\nEnter 'Y' to decode another instruction, or 'N' to end" << endl;
			cin >> choice;
			validChoice = (choice == "Y" || choice == "y" || choice == "N" || choice == "n");
		} while (!validChoice);
	} while (choice == "Y" || choice == "y");
	cout << "\nEnding execution.  We hope this program was as unpleasant to use as it was to write." << endl;
}

void getTable() {
	string mnem, name, fullName, format, opCode;
	while (mnem != "X") {//last entry has mnemonic X
		cin >> mnem;
		fullName = "\0";
		cin >> name;
		while (name != "RR"&&name != "RX") {
			fullName += name;
			cin >> name;
			if (name != "RR"&&name != "RX")
				fullName += ' ';
		}
		format = name;
		cin >> opCode;
		cout << "\t{ \"" << mnem << "\", \"" << fullName << "\", \"" << format << "\", \"" << opCode << "\", ";
		if (format == "RR")
			cout << "processRR }," << endl;
		else
			cout << "processRX }," << endl;
	}
}

string strToUpper(string original) {
	for (int i = 0; original[i] != '\0'; i++)
		original[i] = toupper(original[i]);
	return original;
}

bool validateHex(string userHex) {
	if (userHex.length() != 4 && userHex.length() != 8 && userHex.length() != 12) {
		cout << "\nValue " << userHex << " is not a valid length -- re-enter" << endl;
		return false;//invalid length
	}
	for (int i = 0; userHex[i] != '\0'; i++) {
		if (!((userHex[i] >= 'a' && userHex[i] <= 'f') || (userHex[i] >= 'A'&&userHex[i] <= 'F') || (userHex[i] >= '0'&&userHex[i] <= '9'))) {
			cout << "\nDigit " << userHex[i] << " is not valid, must be 0-9 or A-F, re-enter" << endl;
			return false;//invalid digit
		}
	}
	return true;//valid digits and length
}

int findOpCode(string userHex) {
	std::stringstream ss;
	string userCode = "\0";
	int i = 0;//index to iterate through the code table
	bool opCodeFound = false;
	userCode += userHex[0];
	userCode += userHex[1];
	for (i = 0; i < TOTALENTRIES && !opCodeFound; i++)
		opCodeFound = (userCode == CODETABLE[i].opCode);
	if (!opCodeFound) {
		cout << "\nOperation Code " << userCode << " is not known" << endl;
		return -1;
	}
	return i - 1;
}

int hexToInt(string hexString) {
	stringstream ss;
	int tempInt;
	ss << hex << hexString;
	ss >> tempInt;
	ss.clear();
	return tempInt;
}

void processRR(string hexInst, int codeIndex) {
	int R1, R2;

	R1 = hexToInt(hexInst.substr(2, 1));
	R2 = hexToInt(hexInst.substr(3, 1));

	cout << "\n" << CODETABLE[codeIndex].name << "\t" << CODETABLE[codeIndex].mnem << "\t"
		<< R1 << "," << R2 << endl;
}

void processRX(string hexInst, int codeIndex) {
	int M1, D2, X2, B2;
	hexInst += "0000";//prevents crash if string of 4 chars was passed
	M1 = hexToInt(hexInst.substr(2, 1));
	X2 = hexToInt(hexInst.substr(3, 1));
	B2 = hexToInt(hexInst.substr(4, 1));
	D2 = hexToInt(hexInst.substr(5, 3));

	cout << "\n" << CODETABLE[codeIndex].name << "\t" << CODETABLE[codeIndex].mnem << "\t"
		<< M1 << "," << D2 << "(" << X2 << "," << B2 << ")" << endl;
}