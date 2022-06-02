package tomcat.socket;

import java.io.StringReader;

import com.google.gson.Gson;

import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.websocket.DecodeException;
import jakarta.websocket.Decoder;

public class MessageDecoder implements Decoder.Text<ChatMessage>{

	@Override
	public ChatMessage decode(String s) throws DecodeException {
		System.out.println("Decoding: "+ s);
		/*ChatMessage chatMessage = new ChatMessage();
		JsonObject jsonObject = Json.createReader(new StringReader(s)).readObject();
		chatMessage.setFrom(jsonObject.getString("from"));
		chatMessage.setContent(jsonObject.getString("content"));
		*/
		Gson gson = new Gson();
		ChatMessage chatMessage = gson.fromJson(s, ChatMessage.class);
		return chatMessage;
	}

	@Override
	public boolean willDecode(String s) {
		
		try {
			//Json.createReader(new StringReader(s)).readObject();
			Gson gson = new Gson();
			gson.fromJson(s, ChatMessage.class);
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
