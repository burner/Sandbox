import gtk.MainWindow;
import gtk.AboutDialog;
import gtk.Label;
import gtk.Button;
import gtk.VBox;
import gtk.Main;

class ButtonUsage : MainWindow
{
	Label StatusLbl;
	this()
	{
		super("Button Usage");
		setDefaultSize(200, 100);
		VBox box = new VBox(false, 2);
		StatusLbl = new Label("Click a Button");
		box.add(StatusLbl);
		box.add(new Button("Button 1", &onBtn1));
		box.add(new Button("Exit", &onBtn2));
		box.add(new Button("About", &onBtn3));
		add(box);
		showAll();	
	}
	void onBtn1(Button button)
	{
		StatusLbl.setText("You Clicked Button 1");
	}
	void onBtn2(Button button)
	{
		Main.exit(0);
	}
	void onBtn3(Button button)
	{
		with (new AboutDialog())
		{
			string[] names;
			names ~= "Jake Day (Okibi)";
			setAuthors(names);
			setWebsite("http://ddev.ratedo.com");
			showAll();
		}
	}
}

void main(string[] args)
{
	Main.init(args);
	new ButtonUsage();
	Main.run();
}
