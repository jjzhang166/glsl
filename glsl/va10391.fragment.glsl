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
const vec3 color = vec3(.3,.6,1.), color2 = vec3(1.,.6,.3);
const float scale = 0.0003,
	    timestep = .05,
	    diststep = .1;

const int particles = 50;

vec2 f(float t){
    return vec2(
	tan(t*t*.15) + 4.8,
	sin(t*5.5) + cos(t*2.) + 1.8
    ) * .3;
}

vec2 map(in vec2 pos){
	return vec2(pos.x * sqrt(1.-pos.y*pos.y*2.), pos.y * sqrt(1.-pos.x*pos.x*2.));
}

void main( void ) {
	float t = (time+1000.) * timestep;
	vec2 pos = getPos(), point, d;
	float totald = 0., floati;
	for( int i = 0; i < particles; i++){
	    floati = float(i);
	    point = f(t+diststep*floati);
	    d = point - pos;
	    totald += (scale * ((floati*.29*point)/float(particles))) / dot(d,d);
	}
	
	float totald2 = 0.;
	for( int i = 0; i < particles; i++){
	    floati = float(i);
	    point = vec2(2.9,1.)-f(-t+diststep*floati);
	    d = point - pos;
	    totald2 += .05*(scale * ((floati*.29*point)/float(particles))) / dot(d,d);
	}
	gl_FragColor = vec4((totald+.1)*color + (totald2)*color2,0.);

}