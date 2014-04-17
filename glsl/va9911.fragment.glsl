//Still working on it
//Andreu Lucio

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float Hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

float Noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),
                    mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);
    return res;
}

float Perlin(in vec2 xy)
{
	float w = .65;
	float f = 0.0;

	for (int i = 0; i < 8; i++)
	{
		f += Noise(xy) * w;
		w *= 0.5;
		xy *= 2.3;
	}
	return f;
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 outdir ;
	vec2 stepsize = vec2(0.01);
	vec4 dirx = texture2D(backbuffer, position + vec2(1.0,0.0)*stepsize) - texture2D(backbuffer, position - vec2(1.0,0.0)*stepsize);
	vec4 diry = texture2D(backbuffer, position + vec2(0.0,1.0)*stepsize) - texture2D(backbuffer, position - vec2(0.0,1.0)*stepsize);	
	vec2 gradient = vec2(dirx.x,diry.x);
	
	outdir = -(normalize(position-mouse)*0.1)*(Perlin((position+time*0.2))*0.2);
	float circle = 0.7-distance((position*5.0),vec2(mouse*5.0));
	circle = clamp(circle*Perlin(position*3.0),0.0,1.0);
	circle += float(texture2D(backbuffer,position+(gradient*0.01)+(Perlin(position*10.0)*0.005)));
	circle *=0.98;
	gl_FragColor = vec4(circle);

}