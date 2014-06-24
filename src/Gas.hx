import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Gas extends Entity{

	private var image:Image; //Sprite da gasolina
	private var speed:Float; //Velocidade que vai se mover

	public function new(xx:Float, speed:Float){
		super();

		image = new Image("gfx/gascan.png");
		graphic = image;
		layer = 12;
		setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));
		type = "gas";
		x = xx - halfWidth; 	//-halfWidth para centralizar na pista
		y = -image.scaledHeight;//inicia acima da tela
		this.speed = speed;
	}

	override public function update():Void	{
		if (y < HXP.screen.height ){
			//Ainda na tela, então move pra baixo
			y += speed * HXP.elapsed;
		} else {
			//saiu da tela, então pode remover
			HXP.scene.remove(this);
		}
	}

	public function gameOver():Void
	{
		speed = 0;	//a gasolina vai parecer estar parada na pista 
	}
}