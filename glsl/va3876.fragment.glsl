// by rotwang, a house

#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}

vec2 rotate(vec2 p,float angle){
   vec2 q;
   q.x =p.x*cos(angle)-p.y*sin(angle);
   q.y =p.x*sin(angle)+p.y*cos(angle);
   return q;
}

float smoothHexPrism( vec2 p, float h, float smooth )
{
    vec2 q = abs(p); 
    float d = dot(q, vec2(0.866025, 0.5));
	
	
	float shade = max(d, q.y)-h;
	 shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
    return shade;
}

float roof( vec2 p, vec2 b )
{
	
	p.y -= 0.5;
	p *= vec2(sqrt(2.0),2.0);
	p = rotate(p,PI/4.0);

	vec2 v = abs(p) - b;
	;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, 1.0/8.0);
}

float rect( vec2 p, vec2 b )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, 1.0/8.0);
}

float house( vec2 p, vec2 b )
{
	vec2 q=p;
  	float d1 = rect(p,b);
	q *= vec2(3.0,2.0);
	q.y += 0.5;
	float d2 = rect(q,b);
	float d = d1-d2;
	float d3 = roof(p,b);
	d = max(d,d3) + d*0.25;
	
	p.y -= 0.3;
	p *= 1.66;
	float d4 = smoothHexPrism(p, 0.25, 0.01);
	d -= d4;
	return d;
}




void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	// scroll
	//pos.x += time*0.1;
	
	
	float d = house(pos+vec2(0.0,0.25), vec2(0.5,0.5)); 
	
	
	vec3 clr = vec3(0.9,0.6,0.5) *d; 
			

	
	gl_FragColor = vec4( clr , 1.0 );

}