import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
#if !mobile
import com.haxepunk.utils.Key;
#end
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.utils.Data;
import com.haxepunk.utils.Touch;

class PlayScene extends Scene
{
	private var player:Player; 			//Jogador
	private var track1:Image;			//2 imagens para a pista para dar a ilusão
	private var track2:Image;			//de pista infinita
	private var laneWidth:Float;		//largura de uma pista individual
	private var trackRightEdge:Float;	//posição do limite direito da pista
	private var laneX:Array<Float>;		//Um array das X psições de cada pista
	private var gameSpeed:Float;		//A velocidade atual para mover as imagens das pistas

	private var hud:Image;

	private var tempoBaseAdversario:Float; 	//tempoAdversario inicia nesta quantidade
	private var tempoBaseMaxAdversario:Float; 	//Define um valor máximo para o tempo
	private var tempoAdversario:Float;		//contador para adicionar um novo driver
	private var baseGasTimer:Float; 	//gasTimer inicia nesta quantidade
	private var gasTimer:Float;			//contador para adicionar um novo gas

	private var gameover:Bool;			//Define quando o jogo for encerrado ou não
	private var tempoMensagemFinal:Float; //a quantidade de tempo antes do jogo terminar

	private var playerTween:LinearMotion; //efeito de movimentação do jogador

	private var distance:Float;			//Define a distância que o jogador viajou

	private var healthText:Text;		//texto para exibir a saúde do jogador;
	private var gasText:Text;			//texto para exibir a quantidade de gasolina atual;
	private var distanceText:Text;		//texto para exibir a distância percorrida;
	private var textoGameOver:Text; 	//texto indicando fim do jogo
	private var textoNovoHighScore:Text;//texto indicando que novo highscore foi alcançado.

	private var novoAumentoVeloc:Int;	//Define a distância percorrida até alterar a velocidade
	private var novoLimiteVeloc:Int;	//Define novo limite velocidade
	private var maxVeloc:Int;			//Define a velocidade máxima
	private var textoAumentaVelocidade:Text;		//Texto para indicar aumento de velocidade

	private var Touch1:Float;
	private var touched:Bool;

	private var pause:Bool;




	public function new()
	{
		super();
		pause = false;
		Touch1 = 0;
		touched = false;
		Data.load("saveHighScore"); //Carrega a pontuação máxima

		track1 = new Image("gfx/track.png");
		track1.y = 0;                        //placed at the top of the screen
		addGraphic(track1, 15); //addGraphic() adds an image to the scene, in this case, on layer 15. Higher layers are drawn first.
		track2 = new Image("gfx/track.png");
		track2.y = -track2.scaledHeight;     //placed immediately above the first track image
		addGraphic(track2, 15);

		laneWidth = 80;
		laneX = [20, 120, 220, 320];
		trackRightEdge = laneX[3] + laneWidth + 20;

		gameSpeed = 240;
		distance = 0;
		tempoBaseAdversario = 4.5;
		tempoBaseMaxAdversario = 5;
		tempoAdversario = 2;
		baseGasTimer = 8.75;
		gasTimer = baseGasTimer;
		gameover = false;
		tempoMensagemFinal = 3;

 		novoAumentoVeloc = 100;
		novoLimiteVeloc = 300;
		maxVeloc = 800;

		hud = new Image("gfx/hud.png");
		hud.x = 0; //Posiciona o fundo no canto esquerdo
		hud.y = HXP.screen.height * .75; //75% da altura da tela
		addGraphic(hud);

		textoAumentaVelocidade = new Text("SPEED UP!!");
		textoAumentaVelocidade.color = 0xff5500;
		textoAumentaVelocidade.size = 35;
		textoAumentaVelocidade.x = HXP.screen.width * .5 - (textoAumentaVelocidade.scaledWidth * .5); 
		textoAumentaVelocidade.y = track1.scaledHeight * .5;

		textoGameOver = new Text("GAME OVER");
		textoGameOver.color = 0xff5500;
		textoGameOver.size = 50;
		textoGameOver.x = HXP.screen.width * .5 - (textoGameOver.scaledWidth * .5); 
		textoGameOver.y = track1.scaledHeight * .5;

		textoNovoHighScore = new Text("NEW HIGHSCORE!!!");
		textoNovoHighScore.color = 0xff5500;
		textoNovoHighScore.size = 35;
		textoNovoHighScore.x = HXP.screen.width * .5 - (textoNovoHighScore.scaledWidth * .5); 
		textoNovoHighScore.y = textoGameOver.y + textoGameOver.scaledHeight;

		healthText = new Text("Health: 3");
		healthText.color = 0xffff00;
		healthText.size = 28;
		healthText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (healthText.scaledWidth * .5);
		healthText.y = (HXP.screen.height * .80) - (healthText.scaledHeight * .5);
		addGraphic(healthText, 0);

		gasText = new Text("Gas: 100");
		gasText.color = 0xffff00;
		gasText.size = 28;
		gasText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (gasText.scaledWidth * .5);
		gasText.y = (HXP.screen.height * .85) - (gasText.scaledHeight * .5);
		addGraphic(gasText, 0);

		distanceText = new Text("Distance: 0");
		distanceText.color = 0xffff00;
		distanceText.size = 28;
		distanceText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (distanceText.scaledWidth * .5);
		distanceText.y = (HXP.screen.height * .90) - (distanceText.scaledHeight * .5);
		addGraphic(distanceText, 0);

		player = new Player();
		player.x = laneX[1] + (laneWidth * .5) - player.halfWidth; //start in second lane
		player.y = (HXP.screen.height * .75) - (player.height + 20);
		add(player); //adds an entity to the scene		

		playerTween = new LinearMotion();
		playerTween.x = player.x;
		playerTween.y = player.y;
		player.addTween(playerTween);

		#if !mobile
		Input.define("left", [Key.A, Key.LEFT]);
		Input.define("right", [Key.D, Key.RIGHT]);
		Input.define("pause", [Key.P]);
		#end

		tempoExibicaoMensagem = 1.5;
		tempoMensagem = tempoExibicaoMensagem;
		aumentouVelocidade = false;

		textoAumentaVelocidade.visible = false;
		addGraphic(textoAumentaVelocidade);

	}

	private var tempoMensagem:Float; //Contador de exibição da mensagem
	private var tempoExibicaoMensagem:Float; //
	private var aumentouVelocidade:Bool; //Verificador de aumento da velocidade
	
	#if mobile
	private function onTouch(touch:Touch)
	{
			//SWIPE GESTURE ?!
			//Se a tela for tocada
			//Touch1 = posição X do toque
			//touched indica que a tela está sendo pressionada
			if(touch.pressed && !touched){
				Touch1 = touch.x;
				touched = true;
			}
			//Quando a diferença entre o toque inicial e o toque atual
			//For maior que a largura da tela / 12
			//E a tela está sendo tocada
			//Move para direita ou para a esquerda
			if ( diference(Touch1, touch.x) > (HXP.width / 12) && touched && Touch1 > touch.x ) {
				move("left");
				touched = false;
			}
			if ( diference(Touch1, touch.x) > (HXP.width / 12) && touched && Touch1 < touch.x ) {
				move("right");
				touched = false;
			}

	}
	#end

	override public function update():Void {
		super.update();
		if(Input.pressed("pause")) { pause = !pause; }
		if(pause){
		      return;
		} else {

		//Quando a distância chegar no nível indicado e a velocidade for até X
		if (distance >= novoAumentoVeloc && gameSpeed <= maxVeloc ){

			aumentouVelocidade = true;
			
			//Aumenta velocidade progressivamente
			do {
				gameSpeed += 2;
			} while (gameSpeed <= novoLimiteVeloc );

			//Aumenta os novos níveis.
			novoAumentoVeloc += 100;
			novoLimiteVeloc += 100;
		}

		//Se a velocidade aumentar, exibe a mensagem após alguns segundos
		if(aumentouVelocidade){
		    if (tempoMensagem > 0) { 
				tempoMensagem -= HXP.elapsed;
				textoAumentaVelocidade.visible = true;  //Exibe a mensagem
			} else {
				textoAumentaVelocidade.visible = false; //Oculta a mensagem
				aumentouVelocidade = false;
				tempoMensagem = tempoExibicaoMensagem; //Reseta o tempo da mensagem
			}
		}
		

		if(gameover) {
			//*FIM DE JOGO (VIDAS = 0 ou GAS = 0)*//
			//Cria o aviso de fim de jogo
			addGraphic(textoGameOver);

			//pontosAtual recebe a maior pontuação já feita
			var pontosAtual:Int = Data.readInt("pontos");

			//Se a distância atual(que é o que gera os pontos
			//for maior do que a maior pontuação já feita
			//gera o aviso de Novo High Score
			if (distance > pontosAtual) {
				addGraphic(textoNovoHighScore);
			}

			//Caso a pontuação atual seja maior do que a maior pontuação
			//Salva este valor no objeto Data(saveHighScore)
			if(distance >= pontosAtual){
				Data.write("pontos", HXP.round(distance, 1));
			    Data.save("saveHighScore");
			}
			
			//Aqui é contabilizado o tempo de exibição da mensagem
			//de game over e a pontuação alcançada
			//quando o tempo esgota, remove todos os elementos da cena
			//e retorna à tela de título
			if(tempoMensagemFinal > 0) {
				tempoMensagemFinal -= HXP.elapsed;
			} else {

				HXP.scene.removeAll();
				HXP.scene = new TitleScene();
			}
		} else {
			//*MOVIMENTAÇÃO DA PISTA*//
			//Ambas as imagens descem verticalmente de acordo com a
			//velocidade do jogo
			//Quando uma das pistas chega ao fim da tela, ela é
			//movida para o início da outra, dando um efeito de
			//movimento infinito
			track1.y += gameSpeed * HXP.elapsed;
			track2.y += gameSpeed * HXP.elapsed;
			if(track1.y > track1.scaledHeight ) {
				track1.y = track2.y - track1.scaledHeight;
			} else if(track2.y > track2.scaledHeight) {
				track2.y = track1.y - track2.scaledHeight;
			}

			
			//*CRIAÇÃO DE INIMIGOS*//
			//Diminui o tempo de criação entre um adversário e outro
			//Quando o contador zera, cria um inimigo em uma
			//no meio (laneWidth * .5) pista (laneX[])
			//aleatória (HXP.rand(4)) que varia entre 0 e 3
			//e uma velocidade um pouco menor do que a velocidade
			//do jogo, para criar a ilusão de movimento do adversário na pista
			//adiciona o objeto na cena
			//

			if(tempoAdversario > 0) {
				tempoAdversario -= HXP.elapsed;
			} else {
				var d:Driver = new Driver(laneX[HXP.rand(4)] + (laneWidth * .5), gameSpeed - 60);
				add(d);
				tempoBaseMaxAdversario = HXP.random();
				trace(tempoBaseMaxAdversario);
				tempoBaseAdversario -= .05;
				tempoAdversario += tempoBaseAdversario;

			}

			if(gasTimer > 0) {
				gasTimer -= HXP.elapsed;
			} else {
				var g:Gas = new Gas(laneX[HXP.rand(4)] + (laneWidth * .5), gameSpeed);
				add(g);
				baseGasTimer -= .05;
				gasTimer += baseGasTimer;
			}

			#if mobile
			if (Input.multiTouchSupported){
				Input.touchPoints(onTouch);
			}

			#else
			if(Input.pressed("left")) { move("left"); }
			if(Input.pressed("right")) { move("right"); }
			#end


			//update the text entities
			healthText.text = "Health: " + player.health;
			healthText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (healthText.scaledWidth * .5);
			gasText.text = "Gas: " + HXP.round(player.gas, 1);
			gasText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (gasText.scaledWidth * .5);
			distanceText.text = "Distance: " + HXP.round(distance, 1);
			distanceText.x = 10;//HXP.screen.width - ((HXP.screen.width - trackRightEdge) * .5) - (distanceText.scaledWidth * .5);
			player.x = playerTween.x; //this actually moves the player during the tween

			if(player.gas > 0 && player.health > 0) {
				gameSpeed += .05 * HXP.elapsed;
				distance += 10 * HXP.elapsed;
				player.gas -= 5 * HXP.elapsed;
				if(player.gas < 0) {
					player.gas = 0;
				}
			} else {
				gameover = true;
				var drivers:Array<Driver> = [];
				var gascans:Array<Gas> = [];
				getType("driver", drivers);
				for(d in drivers) {
					d.gameOver();
				}
				getType("gas", gascans);
				for(g in gascans) {
					g.gameOver();
				}
			}
		}/*Fim gameOver*/
		}/*fim pause*/

	} /*FIM update*/

	private function move(dir:String):Void {
		if(dir == "left") {
			if(player.curLane > 0) {
				player.curLane -= 1;
				playerTween.setMotion(player.x, player.y, laneX[player.curLane] + (laneWidth * .5) - player.halfWidth, player.y, .25);
			}
		} else {//assuming that dir == "right" 
			if(player.curLane < laneX.length - 1) {
				player.curLane += 1;
				playerTween.setMotion(player.x, player.y, laneX[player.curLane] + (laneWidth * .5) - player.halfWidth, player.y, .25);
			}
		}
	}	

	private function diference(inicial:Float, final:Float)
	{
		if(inicial >= final){
		    return inicial - final;
		} else {
			return final - inicial;
		}
	}

}