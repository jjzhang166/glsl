// WIP
// 'Ray Banned Leafs' by rotwang(2012)
// using stuff from clover by iq


#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float unsin(float t)
{
	return sin(t)*0.5+0.5;
}

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}



float leafs( vec2 pos, float t, float count )
{
    float a = atan(pos.x,pos.y);
	a *=  count;
    float r = length(pos);
    float invr = 1.0-r;
    float s = unsin(a);
    float g = sin(1.57+a+t);
    float d = sqrt(s) + 0.5*g*g;
    float h = r/(d*r)*g;
	float smooth = 0.25 * invr;
    float f = 1.0-smoothstep( 0.05-smooth, 0.05+smooth, invr*h );
   f += smoothstep( f-0.05, f+0.05, invr );
	f *= 0.75 * invr*d;
	return f ;
}

vec3 scene1( in vec2 pos, float t1)
{

     float r = length(pos);
    float invr = 1.0-r;
	

    float t2 = t1*.5;
    float t3 = t2*.33;
    float t4 = t3*.25;


	
	vec2 posta =  mix(pos, pos*r, unsin(t2));
	vec2 postb =  mix(pos, pos*invr, unsin(1.0-t3));
	float a = leafs( posta, time,3.0 );
	float b = leafs( postb, time*0.5,3.0 );
	float huebase = mod(t4/2.0, 0.5);
	float hue = huebase + 0.5*r + 0.25*sin(t4);
	vec3 clr = hsv2rgb(hue, 0.25, (a+b)/2.0);
	

	return clr;

}

vec3 scene2( in vec2 pos, float t1)
{

     float r = length(pos);
    float invr = 1.0-r;
	
	

    float t2 = t1*.5;
    float t3 = t2*.33;
    float t4 = t3*.25;
	
    vec2 uv;
	float x = unsin(t4) + pos.x*cos(t4)-pos.y*sin(t4);
    float y = pos.x*sin(t4)+pos.y*cos(t4);
     
    uv.x =  (x*x)/abs(y);
    uv.y =   sin(t2)/abs(y);
	
	uv = smoothstep( uv*0.36,uv*0.99, vec2(invr));
	
        pos = mix(pos, pos*uv * y*y, unsin(t3));
	float m = leafs( pos+vec2(y,x), unsin(t4), 2.0 );
	pos = mix(pos, pos *x*x*r, m);
	
	vec2 posta =  mix(pos, uv*r, unsin(t2));
	vec2 postb =  mix(pos, uv*invr, unsin(1.0-t3));
	float a = leafs( posta, time,3.0 );
	float b = leafs( postb, time*0.5,3.0 );
	float huebase = mod(t4/2.0, 0.5);
	float hue = huebase + 0.5*r + 0.25*sin(t4);
	vec3 clr = hsv2rgb(hue, 0.25, (a+b)/2.0);
	
	float fin = smoothstep(0.0, 2.0, t4);
	clr *= fin;
	return clr;

}

void main( void ) {

	float aspect = resolution.x /resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
	vec2 pos = unipos*2.0-1.0;
	pos.x *=aspect;
  
	vec3 clr_a = scene1(pos, time);
	vec3 clr_b = scene2(pos, time);

	float blend = smoothstep( 0.9, 1.0, unsin(time/12.0));
	
	vec3 clr =  mix( clr_a, clr_b, blend);
	
	
	float fin = smoothstep(0.0, 2.0, time/4.0);
	clr *= fin;
	
	gl_FragColor = vec4( vec3(clr), 1.0);
}