// by rotwang: some shape development for the Krysler demo (2012)
// segment function from 'Shapes' by iq (2011)
// rotwang: @mod circle and ring function
// @mod+ atan section shading
// @mod+ atan with start angle
// @mod+ rounded rect
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323;
const float TWOPI = PI*2.0;

float osc1 = sin(time)*0.5+0.5;
//float env1 = mod(time*0.25, 4.0);
float env1 = fract(time*0.25);




vec2 rotated(float a, float r) {
	
	return vec2(cos(a*TWOPI)*r, sin(a*TWOPI)*r);
}

float circle(vec2 pos, float radius, float smooth) {
	
	float len = length( pos );
	float d = smoothstep( radius-smooth, radius+smooth, len );
	return d;
}

float ring(vec2 pos, float ra, float rb, float smooth) {
	
	float len = length( pos )-0.2;
	
	
	float a = smoothstep( ra-smooth, ra+smooth, len );
	float b = smoothstep( rb-smooth, rb+smooth, len );
	return b-a;
}

float Krysler_117(vec2 pos, float ra, float rb, float smooth) {
	
	float len_a = length( pos );
	float len = sqrt( pow(pos.x, 4.0)+ pow(pos.y, 4.0*len_a ));
	
	float a = smoothstep( ra-smooth, ra+smooth, len );
	float b = smoothstep( rb-smooth, rb+smooth, len );
	return b-a;
}

float unatan(vec2 p, float start)
{
	float a= atan(p.x, p.y);
	a/=TWOPI;
	a += 0.5;
	a = fract(a+start);
	return a;
}

vec3 ring01(vec2 p)
{
	float g = unatan(p, -0.2 * time );
	float shade = Krysler_117( p, 0.66, 0.33, 0.01)+g;
	float shade_b = Krysler_117( p, 0.66, 0.43, 0.01)* 0.5-p.x+g;
	

	shade *= g;
	//shade *= max(g, dot(p,rotated(g,1.0)));
	//shade *= 1.0-length(p);
	float red = shade*0.35*p.x + shade_b*0.2;
	float green =  shade*0.5*p.x + shade_b*0.1;
	vec3 clr = vec3(red, green, shade*0.99*p.x);
	return clr*1.5;

}

vec3 ring02(vec2 p)
{
	
	float shade = ring( p, 0.66, 0.33, 0.01);
	
	float g = unatan(p, 0.0 );
	g = mod(g, 0.25);
	shade *= g*3.0;
	shade *= max(g, dot(p,rotated(g,1.5)));
	shade *= 3.0-length(p);
	vec3 clr = vec3(shade, shade*0.6, shade*0.2);
	return clr;

}


vec3 sun( vec2 pos )
{
    float a = atan(pos.x,pos.y);
    float r = length(pos); // sqrt(x*x+y*y);

    float s = 0.5 + 0.5*sin(a*17.0+1.5*time);
    float d = 0.5 + 0.2*pow(s,1.0);
    float h = r/d;
    float f = 1.0 -smoothstep(0.92,1.0,h);

    float b = pow(0.5 + 0.5*sin(3.0*time),500.0);
   // vec2 e = vec2( abs(pos.x)-0.15,(pos.y)); //*(1.0+10.0*b) );
	vec2 e = pos; // vec2( pos.x,pos.y);
   // float g = 1.0 - (segm(0.1,0.2,0.01,length(e))); //*step(0.0,e.y);
	
	/*
	float ca = circle( pos, 0.1, 0.01);
	float cb = circle( pos, 0.2, 0.01);
	return vec3(ca-cb);
	*/
	float g = 0.0; // ring( pos, 0.66, 0.05);
	return vec3(g, g*0.6, g*0.2);
	
  //  float t = 0.5 + 0.5*sin(12.0*time);
  //  vec2 m = vec2( pos.x, (pos.y+0.15)*(1.0+10.0*t) );
  //  g *= 1.0 - (segm(0.06,0.09,0.01,length(m)));

   // return mix(vec3(0.0,0.5,0.8),vec3(0.99,0.9,0.1)*g,f);
}

void main( void ) {

	float speed = time *0.5;
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;


	vec3 clr = ring01(pos);
   // vec3 clr = sun( pos );
    
    gl_FragColor = vec4(clr,1.0);

}