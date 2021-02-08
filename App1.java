import java.sql.*;
class App1
{	public static void main(String args[])
	{	try
		{	String path = "jdbc:mysql://localhost/nibm";
			Connection con = DriverManager.getConnection(path,"root","");
			Statement st = con.createStatement();
			//st.executeUpdate("insert into student values(2,'saman')");
			//st.executeUpdate("update student set sname='Kamal' where sno=2");
			//st.executeUpdate("delete from student where sno=2");

			ResultSet rst = st.executeQuery("select sno,sname from student");
			while(rst.next())
			{	System.out.println(rst.getInt(1)+"\t"+rst.getString(2));
			}
			con.close();
		}
		catch (Exception e)
		{	System.out.println(e.getMessage());
		}
 	}
}
