import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Driver extends Entity{

	private var image:Image; //Sprite do driver
	private var speed:Float; //Velocidade que irá mover-se

	public function new(xx:Float, speed:Float){
		super();
		image = new Image("gfx/driver.png");
		graphic = image;
		layer = 12;
		setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));
		type = "driver";
		x = xx - halfWidth; //- halfWidth para centralizar nesta pista
		y = -image.scaledHeight; // inicia acima da tela
		this.speed = speed;
	}

	override public function update():Void	{
		if (y < HXP.screen.height){
			//Ainda na tela, então move pra baixo
			y += speed * HXP.elapsed;
		} else {
			//saiu da tela, então pode remover
			HXP.scene.remove(this);
		}
	}

	public function gameOver():Void
	{
		speed *= -1;	//o veículo vai parecer estar andando
	}
}