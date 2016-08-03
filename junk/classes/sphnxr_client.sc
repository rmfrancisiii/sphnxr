SphnxrClient : Object {

	//  Session Client:
	//
	//     Can provide streams or sphincters or both
	//
	/////////
	//
	// Class Variables
	// - <globalClientList
	//
	// Instance Variables:
	// - <>clientName
	// - <>clientPort
	// - <>clientAddr
	// - <clientStreamList
	// - <clientSphincterList
	// - <sessionSphincter
	//
	// Class Methods
	// - *new
	// - *kill
	//
	// Instance Methods
	// - addStream
	// - killStream
	// - listStreams
	// - addSphincter
	// - killSphincter
	// - listSphincters
	//
	/////////////////////



	*new{|clientName, clientPort, clientAddr|
		^super.newCopyArgs(sphincter, stream);
	}

	*kill{

	}
}