package tomcat.socket;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import jakarta.websocket.EncodeException;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/websocketserver/{user}", decoders = MessageDecoder.class, encoders = MessageEncoder.class )
public class WebSocketServer {

	private static Set<WebSocketServer> chatEndpoints = new CopyOnWriteArraySet<>();

	public WebSocketServer() {
		System.out.println("WebSocket server Class Loaded: " + this.getClass());
	}

	@OnOpen
	public void onOpen(@PathParam("user") String user, Session session) {
		System.out.println("Session Opened with Id: " + session.getId());
		System.out.println(user + " has opened the connection.");
		chatEndpoints.add(this);
		try {
			//session.getBasicRemote().sendText("ChatApp: Hi, we are successfully connected");
			try {
				session.getBasicRemote().sendObject(new ChatMessage("ChatApp","Hi "+user+", We are successfully connected"));
			} catch (EncodeException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	@OnMessage
	public void onMessage(ChatMessage message, Session session) {
		System.out.println("Message Received <" + session.getId() + ">: " + message);

		Set<Session> openSessions = session.getOpenSessions();
		for (Session ses : openSessions) {
			try {
				System.out.println("Sending: " + message + " to: " + ses.getId());
				//ses.getBasicRemote().sendText(message.getFrom() + ":"+message.getContent());
				try {
					ses.getBasicRemote().sendObject(message);
				} catch (EncodeException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		/*
		 * try { session.getBasicRemote().sendText( "Hello " + session.getId() +
		 * ", this is Server. I have received your message as: " + message); } catch
		 * (IOException e) { // TODO Auto-generated catch block e.printStackTrace(); }
		 */
	}

	@OnError
	public void onError(Throwable error) {
		error.printStackTrace();
	}

	@OnClose
	public void onClose(Session session) {
		System.out.println("Session Closed with id: " + session.getId());
	}

}