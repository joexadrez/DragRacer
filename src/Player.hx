import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class Player extends Entity {

	public var health:Int;   //A energia do veículo
	public var gas:Float;	 //A quantidade de gasolina restante
	private var image:Image; //O sprite do jogador
	public var curLane:Int;  // Pista atual
    public var contaGas:Int; //Conta gasolina pega

	

	public function new() { 
       	super(); 
 
        image = new Image("gfx/player.png"); 
        graphic = image; 
        layer = 9; 
        setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight)); 
        type = "player";
        health = 3; 
        gas = 100;
        contaGas = 0;
        curLane = 1;
    } 

    override public function update():Void
    {
        var collobj:Entity = collide("driver", x, y);
        if (collobj != null) {
            //colide com um driver
            health -= 1;
            HXP.scene.remove(collobj);
        }
        collobj = collide("gas", x, y);
        if (collobj != null) {
            //colide com a gasolina
            gas += 50;
            if (gas > 100) {
                gas = 100;
            }
            HXP.scene.remove(collobj);

            //Quanto pegar 5 gasolinas, aumenta 1 vida
            if (contaGas < 4) {
                contaGas ++;
            } else {
                health ++;
                contaGas = 0;
            }
            
        }
    }
}