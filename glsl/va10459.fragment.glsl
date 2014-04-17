#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 getPos() {
        vec2 pos = ( gl_FragCoord.xy / resolution.xy );
        pos.x *= resolution.x / resolution.y;
        return pos;
}

vec2 cmult(in vec2 a, in vec2 b){ return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x); }

float iterate(vec2 c){
	vec2 z = c;
	for(int i = 0; i < 25; i++){
		z = cmult(z,z)+c;
		if(dot(z,z) > 4.) return float(i) / 25.;
	}
	
	return 1.;
}

vec2 center(vec2 pos){
    pos = floor(pos);
    return pos;
}

vec2 tile(vec2 pos){
    return pos - center(pos) - vec2(.5,.5);
}

const float SCALE = 70.;
void main( void ) {
	vec2 position = getPos()*SCALE - vec2(SCALE,SCALE*0.5),
	     sctime = vec2(sin(time),cos(time)) * SCALE * .0625;
	//position = vec2(position.x*cos(time) - position.y*sin(time), position.x*sin(time) + position.y*cos(time));
	vec2 mandelpos = (center(position)+sctime) / SCALE * 10.;
	vec2 c = tile(position);
	float dist = dot(c,c);
	
	gl_FragColor = vec4( (.6-dist*5.) * (iterate(mandelpos)+.1) * 3.);

}