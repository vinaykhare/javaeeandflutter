package tomcat.socket;

import java.util.ArrayList;

import com.google.gson.Gson;

import jakarta.websocket.DecodeException;
import jakarta.websocket.Decoder;

public class MessageListDecoder implements Decoder.Text<ArrayList<ChatMessage>>{

	@Override
	public ArrayList<ChatMessage> decode(String s) throws DecodeException {
		System.out.println("Decoding: "+ s);
		/*ChatMessage chatMessage = new ChatMessage();
		JsonObject jsonObject = Json.createReader(new StringReader(s)).readObject();
		chatMessage.setFrom(jsonObject.getString("from"));
		chatMessage.setContent(jsonObject.getString("content"));
		*/
		Gson gson = new Gson();
		ArrayList<ChatMessage> chatMessage = gson.fromJson(s, ArrayList.class);
		return chatMessage;
	}

	@Override
	public boolean willDecode(String s) {
		try {
			//Json.createReader(new StringReader(s)).readObject();
			Gson gson = new Gson();
			gson.fromJson(s, ArrayList.class);
			System.out.println("Will Decode: "+ s);
			return true;
		}
		catch (Exception e) {
			System.out.println("Will Not Decode: "+ s);
			e.printStackTrace();
			return false;
		}
	}

}
