import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
#if !mobile
import com.haxepunk.utils.Key;
#end
import flash.text.TextFormatAlign;
import com.haxepunk.utils.Data;

class TitleScene extends Scene
{
	public function new()
	{
		super();

		var title:Text = new Text("Drag Racer");
		title.color = 0xff5500;
		title.size = 48;
		title.x = (HXP.screen.width * .5) - (title.scaledWidth * .5); //center horizontally
		title.y = 0;
		addGraphic(title);

		#if mobile
			var description:Text = new Text("Pressione o lado \nesquerdo ou direito \ndo carro para movê-lo \nEvite os veículos \n pegue os galões.\nPressione a tela \npara comecar.");
		#else
			var description:Text = new Text("Use as setas ou \nA/D para mover.\nEvite os veículos \n pegue os galões.\nPressione Enter \npara começar");
		#end
		description.color = 0x00aaff;
		description.size = 32;
		description.x = (HXP.screen.width * .5) - (description.scaledWidth * .5);   //center horizontally
		description.y = (HXP.screen.height * .5) - (description.scaledHeight * .5); //center vertically
		description.align = TextFormatAlign.CENTER;
		addGraphic(description);

		//Carrega o objeto "saveHighScore", mesmo se ele não existir
		Data.load("saveHighScore");

		//Lê o dado "pontos" que é um Int armazenado dentro 
		//do "saveHighScore" e faz a comparação
		//Se a pontuacao for maior que zero, isto é, se ela existir
		//Cria um novo Text e exibe ele na tela 
		if(Data.readInt("pontos") > 0){ 
			var highScore:Text = new Text("HIGH SCORE:\n" + Data.readInt("pontos"));
			highScore.color = 0x00aaff; //Cor do texto
			highScore.size = 32;		//Tamanho do texto
			//Define a posição horizontal do texto em 50% da tela menos 
			//a metade da largura do próprio texto
			highScore.x = (HXP.screen.width * .5) - (highScore.scaledWidth * .5);   
			//Define a posição vertical do texto em 75% da tela menos 
			//a metade da altura do próprio texto
			highScore.y = (HXP.screen.height * .75) - (highScore.scaledHeight * .5);
			highScore.align = TextFormatAlign.CENTER; //Centraliza o texto
			addGraphic(highScore);	//Adiciona o texto na tela
		}
		

	}

	override public function update():Void
	{
		super.update();

		#if mobile
		if(Input.mousePressed)
		{
			HXP.scene.removeAll();
			HXP.scene = new PlayScene();
		}
		#else
		if(Input.pressed(Key.ENTER))
		{
			HXP.scene.removeAll();
			HXP.scene = new PlayScene();
		}
		#end
	}
}