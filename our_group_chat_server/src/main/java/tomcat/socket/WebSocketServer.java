package tomcat.socket;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.MulticastMessage;
import com.google.firebase.messaging.Notification;
import com.google.firebase.messaging.SendResponse;

import jakarta.websocket.EncodeException;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/websocketserver/{user}/{token}", decoders = MessageDecoder.class, encoders = {
		MessageEncoder.class, MessageListEncoder.class })
public class WebSocketServer {

	// private static Set<WebSocketServer> chatEndpoints = new
	// CopyOnWriteArraySet<>();

	private static List<ChatMessage> messages = new ArrayList<ChatMessage>();
	private static Set<String> registrationTokens = new HashSet<String>();

	public WebSocketServer() {

		try {
			System.out.println("Firebase Apps Count: " + FirebaseApp.getApps().size());
			if (FirebaseApp.getApps().size() <= 0) {
//			FileInputStream serviceAccount = new FileInputStream(
//					"C:\\Users\\vikh0721\\firebasekeys\\ourgroupchat\\our-group-chat-firebase-adminsdk-uethr-84bc1f68d0.json");
//			FileInputStream serviceAccount = new FileInputStream("our-group-chat-firebase-adminsdk-uethr-84bc1f68d0.json");
//			FirebaseOptions options = FirebaseOptions.builder()
//					.setCredentials(GoogleCredentials.fromStream(serviceAccount)).build();
				FirebaseOptions options = FirebaseOptions.builder()
						.setCredentials(GoogleCredentials.getApplicationDefault()).build();
				FirebaseApp.initializeApp(options);
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@OnOpen
	public void onOpen(@PathParam("user") String user, @PathParam("token") String token, Session session) {
		System.out.println("Session Opened with Id: " + session.getId());
		System.out.println(user + " has opened the connection.");
		// chatEndpoints.add(this);
		// messages.add(new ChatMessage("ChatApp", "Hi " + user + ", We are successfully
		// connected"));

		try {
			/*
			 * FCM Multicast Start
			 */
			if (token != null) {
				registrationTokens.add(token);
			}
			System.out.println("Registration tokens: " + registrationTokens);
			MulticastMessage message = MulticastMessage.builder()
					.setNotification(Notification.builder().setTitle("Start Our Group Chat!")
							.setBody(user + "has opened the connection.").build())
					.addAllTokens(registrationTokens).build();
			BatchResponse response;
			response = FirebaseMessaging.getInstance().sendMulticast(message);
			List<SendResponse> responses = response.getResponses();

			for (int i = 0; i < responses.size(); i++) {
				System.out.println("FCM Message Id for: " + i + ": " + responses.get(i).getMessageId());
			}

			/*
			 * FCM Multicast End
			 */

			/*
			 * FCM Singlcast Start
			 */

//			Message message = Message.builder().setNotification(Notification.builder().setTitle("Join Our Group Chat")
//					.setBody(user + " has opened connection.").build()).putData("Status", "Up and Running!").setToken(token).build();
//			String response = FirebaseMessaging.getInstance().send(message);
//			// Response is a message ID string.
//			System.out.println("Successfully sent message: " + response);

			/*
			 * FCM Singlcast End
			 */

		} catch (FirebaseMessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		try {
			session.getBasicRemote().sendObject(messages);
		} catch (IOException | EncodeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	@OnMessage
	public void onMessage(ChatMessage message, Session session) {
		System.out.println("Message Received <" + session.getId() + ">: " + message);
		messages.add(message);
		Set<Session> openSessions = session.getOpenSessions();
		for (Session ses : openSessions) {
			try {
				System.out.println("Sending: " + message + " to: " + ses.getId());
				// ses.getBasicRemote().sendText(message.getFrom() + ":"+message.getContent());
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