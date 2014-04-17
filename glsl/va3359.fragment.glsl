
// sun based on 'Shapes' by iq (2011)
// by rotwang @mod- face removed
// @mod+ sun function with parameters
// @mod* modulate jag count
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float speed = time *0.5;
float aspect = resolution.x / resolution.y;
vec2 unipos = ( gl_FragCoord.xy / resolution );
vec2 pos = vec2( (unipos.x*2.0-1.0)*aspect, unipos.y*2.0-1.0);

float usin(float t)
{
	return sin(t)*0.5+0.5;
}


vec3 sun( vec2 p, float jags, float smooth )
{
    float a = atan(p.x,p.y);
    float r = length(p); 

    float s = usin(a*jags);
    float d = 0.66 + 0.2*pow(s,2.0);
    float h = r/d;
	float w = 0.66;
    float shade = 1.0-smoothstep(w-smooth,w+smooth,h);
	

    vec3 clr = mix(vec3(0.0,0.0,0.5),vec3(0.9,0.6,0.0),shade);
	clr += 1.2-length(p);
	return clr;
}

void main( void ) {
	
	float jags = mod(usin(time*0.25), 6.0) * 12.0;
	vec3 clr = sun(pos,jags, 0.015);
	
	gl_FragColor = vec4( clr, 1.0 );

}