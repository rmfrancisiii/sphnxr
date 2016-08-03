SphnxrSession : Object {

	//  Session:
	//
	//     collection of clients
	//
	/////////
	//
	// Class Variables
	// - <globalSessionList
	//
	// Instance Variables:
	// - <sessionName
	// - <clientList
	// - <routingMatrix
	//
	// Class Methods
	// - *new
	// - *kill
	//
	// Instance Methods
	// - addClient
	// - removeClient
	// - listClients
	// - createMatrix
	// - updateMatrix
	// - updateSession
    //
	/////////////////////

	*new{|clientName, clientPort, clientAddr|
		^super.newCopyArgs(sphincter, stream);
	}

	*kill{

	}
}