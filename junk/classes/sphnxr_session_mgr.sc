SphnxrSessionMgr : Object {

	//  Session Manager:
	//
	//    Creates OSC Listener
	//    Creates initial (self) Client
	//    Creates/destroys sessions
	//
	////////
	//
	// - sessionList[]:Session[0..*]
	// - thisClient:Client[1]
	// - oscListener:OSCListener[1]
	//
	///////
	//
	// - *new
	// - *kill
	// - newSession (name)
	// - joinSession (ip, session)
	// - listSessions
	//
	/////////////////////

	var <sessionList = [];
	var thisClient = Client.new;
	var <>activeSessions;

	*new{

	}

	*kill{

	}

	newSession{|sessionName|
		SphnxrSession.new(sessionName)
	}

	joinSession{|peerName, address, port = 57210|
	}
}