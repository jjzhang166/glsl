// Krysler, by rotwang (2012)
// WIP

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;

float rand2d(vec2 n){ 
  return fract(sin(dot(n,vec2(12.9898,4.1414))) * 43758.5453);
}


float usint(float t)
{
	return sin(t)*0.5+0.5;
}


float trapez( float x, float d)
{
	//float d = 0.1;
	return min( smoothstep(0.0, d, x), 1.0-smoothstep(1.0-d, 1.0, x));

}

vec3 scene1(in vec2 p, float angle, float t)
{
	vec3 clr;
	
	float d = length(p);
	float una = angle / 6.28;
	
		 
	angle *= acos( abs(p.x)/d);
	angle *= asin( abs(p.y)/d);
	p.x = min(cos(angle), 0.0) * d;
	p.y = min(sin(angle),-1.0) *d;
	
	float dt = 20.0;
	float shade_a;
	shade_a = cos(p.y*dt)*sin(t-p.y);
	shade_a *= cos(p.x*dt);

	float shade_b;
	shade_b = cos(p.x*dt)*sin(t-p.x);
	shade_b *= cos(p.y*dt);

	
	float shade = mix(shade_a, shade_b, 0.5);
	
	clr = vec3( shade*0.7, shade*d,shade*d);
	return clr;
}

vec3 scene2(in vec2 p, float angle, float t)
{
	vec3 clr;
	
	float d = length(p);
	
	float dt = 10.0;
	float shade_a;
	shade_a = cos(p.y*dt)*sin(t-p.y);
	shade_a -= cos(p.x*dt);

	float shade_b;
	shade_b = sin(p.x*dt)*cos(t-p.x);
	shade_b -= sin(p.y*dt);

	
	float shade = mix(shade_a, shade_b, sin(t));
	
	clr = vec3(shade);
	return clr;
}

vec3 scene3(in vec2 p, float angle, float t)
{
	vec3 clr= vec3(1.0);
	
	float d = length(p);
	d =  log(d*2.0);
	
	
	float a = atan(p.y, p.x) / (PI*2.0);
	
	
	d = a;
	clr = vec3(d);
	return clr;
}

vec3 shade1(in vec2 p, float angle, float t)
{
	
	float a = fract( abs(p.y*p.y));
	
	
	vec3 clr = vec3(a);
	return clr;
}


vec3 shade2(in vec2 p, float angle, float t)
{
	
	float n = 8.0;
	float y = sin( p.y*n);
	
	vec3 clr = vec3(y);
	return clr;
}


vec3 shade3(in vec2 p, float angle, float t)
{
	
	angle = max(angle, 0.5* abs(sin(angle)));
	float x = trapez( p.x*6.0*angle,0.1)*1.23;
	float y = sin( p.y*32.0);
	
	vec3 clr = 0.5*vec3( min(x*y,x-y) + x*x-y );
	return clr;
}

vec3 shade4(in vec2 p, float angle, float t)
{
	
	p.x += mod(p.y, 0.25);
	//angle = max(angle, 0.5* abs(sin(angle)));
	float x = trapez( abs(p.x)*4.0, 0.18)*1.26;

	float y = sin( p.y*64.0);
	
	vec3 clr = 0.5*vec3( min(x*y,x-y) + x*x-0.5-y );
	return clr;
}

// random shaded quads
vec3 shade5(in vec2 p, float angle, float t)
{
	vec2 q = mod(p, 0.25);
	float shade = rand2d( p-q);
	
	
	
	vec3 clr = vec3(shade);
	return clr;
}


void main( void ) 
{
	float speed = time*0.5;
	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
    
	float sint = sin(speed);
	float cost = cos(speed);	
	float angle = atan(pos.y/pos.x);
	float d = length(pos);
	float invd = 1.0-d;
	vec3 clr = shade4(pos, angle, speed);
	
	clr += invd*0.5;
	
	//vec3 clr = scene1(pos, angle, speed);
	
	
	//if( (pos.y > 0.0)  )
	//	clr -= d*d;
	
	gl_FragColor = vec4(clr, 1.0);
}