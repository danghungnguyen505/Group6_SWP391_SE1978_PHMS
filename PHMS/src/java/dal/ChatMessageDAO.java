package dal;

import java.sql.*;
import java.util.*;
import model.ChatMessage;

public class ChatMessageDAO extends DBContext {

    public void sendMessage(ChatMessage msg) {

        String sql = "INSERT INTO ChatMessage(sender_id, receiver_id, message_text) VALUES (?, ?, ?)";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, msg.getSenderId());
            ps.setInt(2, msg.getReceiverId());
            ps.setString(3, msg.getMessageText());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ChatMessage> getConversation(int user1, int user2) {

        List<ChatMessage> list = new ArrayList<>();

        String sql = """
            SELECT c.*, u.full_name AS senderName
            FROM ChatMessage c
            JOIN Users u ON c.sender_id = u.user_id
            WHERE (sender_id=? AND receiver_id=?)
            OR (sender_id=? AND receiver_id=?)
            ORDER BY sent_time
        """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, user1);
            ps.setInt(2, user2);
            ps.setInt(3, user2);
            ps.setInt(4, user1);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ChatMessage m = new ChatMessage();

                m.setMessageId(rs.getInt("message_id"));
                m.setSenderId(rs.getInt("sender_id"));
                m.setReceiverId(rs.getInt("receiver_id"));
                m.setMessageText(rs.getString("message_text"));
                m.setSentTime(rs.getTimestamp("sent_time"));
                m.setSenderName(rs.getString("senderName"));

                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Integer> getCustomersWhoMessaged(int receptionistId){

        List<Integer> list = new ArrayList<>();

        String sql = """
        SELECT DISTINCT 
        CASE 
            WHEN sender_id = ? THEN receiver_id
            ELSE sender_id
        END as user_id
        FROM ChatMessage
        WHERE sender_id = ? OR receiver_id = ?
        """;

        try{

            PreparedStatement st = connection.prepareStatement(sql);

            st.setInt(1, receptionistId);
            st.setInt(2, receptionistId);
            st.setInt(3, receptionistId);

            ResultSet rs = st.executeQuery();

            while(rs.next()){
                list.add(rs.getInt("user_id"));
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}