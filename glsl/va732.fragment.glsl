// Batman Curve
// http://www.wolframalpha.com/input/?i=batman+curve
// by Caiwan^IR

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 col1 = vec3(.964705882, .990196078, .990196078);

vec4 getColor(vec2 p){	// the batman function
	vec4 col = vec4(vec3(0.0),1.0);
  	
  	float ax = abs(p.x);
  
  	if (
          	((((p.x*p.x)/49.0) + ((p.y*p.y)/9.0) - 1.0) <= 0.0) && (
          	(ax >= 4.0) && ((-2.461955 <= p.y) && (p.y <= 4.0)) ||
          	(ax > 3.0)  && (p.y >= 0.0) ||
          	((-3.0 <= p.y) && (p.y <= 0.0)) &&
          	((-4.0 <= p.x) && (p.x <= 4.0)) &&
          	(((0.5*abs(p.x))+sqrt(1.0-pow((abs(abs(p.x)-2.0)-1.0),2.0))-(1.0/112.0)*10.23369*(p.x*p.x)-p.y-3.0) <= 0.0) ) ||
          	(p.y>0.0) && (((3.0/4.0) <= ax) && (ax <= 1.0)) &&
          	(-8.0*ax-p.y+9.0 >= 0.0) || 
          	((.5 <= ax) && (ax <= (3.0/4.0))) &&
          	((3.0*ax-p.y+(3.0/4.0)) >= 0.0) && (p.y > 0.0) ||
          	(ax <= 0.5) && (p.y > 0.0) && 
          	(((9.0/4.0)-p.y) >= 0.0) || 
          	(ax >= 1.0) && (p.y > 0.0) &&
          	((-.5*ax-1.3553*sqrt(4.0-pow((ax-1.0),2.0))-p.y+2.71052+(3.0/2.0)) >= 0.0)
          	
           )
        {
  		col = vec4(col1,1);
        }
	
	return col;
}

void main( void ) {
  	vec2 pk = ((gl_FragCoord.xy / resolution.xy)- 0.5 )*20.0;
	// this part was taken from Shader Toy of IQ^RGBA 
	//vec2 pb = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec2 pb = pk/5.0;
    vec2 s = pk;

    vec3 total = vec3(0.0);
    vec2 d = (vec2(0.0,0.0)-pb)/40.0;
    float w = 1.0;
    for( int i=0; i<40; i++ )
    {
        vec3 res = getColor(s).rgb;
        res = smoothstep(0.1,1.0,res*res);
        total += w*res;
        w *= .99;
        s += d;
    }
    total /= 40.0;
    float r = 1.5/(1.0+dot(pb,pb));
    gl_FragColor = vec4( total*r,1.0);
}