//the legend of red
//holy dick this is hacky but by god it works
//TODO make moving blocks using better "memory management"
precision highp float;


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define MEMORY_LOCATION vec2(0.5,0.5)

#define BOX vec4
#define NUM_BOXES 4
#define SPEED 0.01


float box(vec2 p,vec4 b){
	if(p.x>b.x&&p.x<b.x+b.z&&p.y>b.y&&p.y<b.y+b.w){
		return 1.;
	}
	return 0.;
}

vec4 boxes[NUM_BOXES];
vec4 state = texture2D(backbuffer, MEMORY_LOCATION);
vec2 player=state.rg;
vec3 color;

//loop thru all boxes and then move the player
void move(vec2 d){
	bool ok=false;
	for(int i=0;i<NUM_BOXES;i++){
		//if player+dxy is inside something, dont move
		vec2 newp=player+d;
		vec4 b=boxes[i];
		if(newp.x+0.1<=b.x||
		   newp.x>=b.x+b.z||
		   newp.y+0.1<=b.y||
		   newp.y>=b.y+b.w){
			ok=true;
		}
		else{
			ok=false;
			//move player to the edge of the box it hit to make collision more smooth
			if(d.x>0.){
				player.x=b.x-0.1;
			}
			if(d.x<0.){
				player.x=(b.x+b.z);
			}
			if(d.y>0.){
				player.y=b.y-0.1;
			}
			if(d.y<0.){
				player.y=(b.y+b.w);
			}
			break;
		}
	}
	if(ok){
		player+=d;
	}
}

void main( void ) {

	vec2 pos=gl_FragCoord.xy / resolution.xy;
	
	
	boxes[0]=BOX(0.15,0.1,0.2,0.1);
	boxes[1]=BOX(0.5,0.1,0.1,0.1);
	boxes[2]=BOX(0.2,0.4,0.1,0.2);
	boxes[3]=BOX(0.7,0.4,0.05,0.05);
	
	for(int i=0;i<NUM_BOXES;i++){
		color.b+=box(pos,boxes[i]);
	}
	
	
	
	if(player.x<mouse.x){
		move(vec2(SPEED,0.));
	}
	if(player.x>mouse.x){
		move(vec2(-SPEED,0.));
	}
	if(player.y<mouse.y){
		move(vec2(0.,SPEED));
	}
	if(player.y>mouse.y){
		move(vec2(0.,-SPEED));
	}
	
	color.r=box(pos,BOX(player,0.1,0.1));
	
	//save the variable to the screen
	if (distance(pos,MEMORY_LOCATION) < 0.1) {
		gl_FragColor = vec4(player,0.,0.);
	}
	//if we arent "writing to memory", draw whatever
	else{
		gl_FragColor = vec4( color, 1.0 );
	}

}