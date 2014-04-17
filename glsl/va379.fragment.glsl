
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand(vec2 n)
{
  return 0.5 + 0.5 *  fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

float mag(vec2 v)
{
    return sqrt(dot(v,v));
}

void main( void ) 
{
	vec2 p = gl_FragCoord.xy;
        float r = mod(time,150.0);
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);

        float x =  resolution.x;
	float y =  resolution.y;
	float a = rand(vec2(100,500));
	float b = rand(vec2(100,500));
	float c = rand(vec2(100,500));
	//float aaq = (y - sign(x)*sqrt(abs(b*x - c)), a - x );

        if(mag(p - resolution/2.0) < r)
           col = vec4(1.0, 0.0, 0.0, 1.0);

	gl_FragColor = col;
}