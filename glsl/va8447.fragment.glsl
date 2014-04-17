#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 rand_mod(vec2 pos, float seed)
{
	return fract( pow(pos+2.0+fract(seed), pos.yx+2.0 )*22222.0 );
}

vec2 rand(vec2 pos, float seed)
{
	return rand_mod( rand_mod(rand_mod(pos, seed), seed), seed);
}

void main( void )
{
	const int U_COLOR = 2;
	const int V_COLOR = 0;
	const float a = 0.02;
	const float b = 0.2;
	const float c = -65.0;
	const float d = 8.0;
	const float dt = 0.005;
	const float scale = 40.0;
	const int connection = 4;
	
	vec2 position = gl_FragCoord.xy / resolution.xy;

	vec2 s[connection];
	s[0] = vec2(0,1);
	s[1] = vec2(1,0);
	s[2] = vec2(0,-1);
	s[3] = vec2(-1,0);
	
	float i =  10.0 * rand(position, time)[0];
	float v = scale * texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[V_COLOR];
	float u = scale * texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[U_COLOR];


	if( v>=30.0 ) {
		v = c;
		u = u + d;
	}

	for(int j=0;j<connection; j++) {
		vec2 pos = (gl_FragCoord.xy+s[j]) / resolution.xy;
		if( rand(pos, float(j)/10.0 )[0] >=0.2 ) { 
			//Excitatory neurons
			i = i + 0.5 *  scale * texture2D(backbuffer, pos)[V_COLOR];
		}else{
			//Inhivitory neurons
			i = i - 1.0 *  scale * texture2D(backbuffer, pos)[V_COLOR];
		}
	}
	
	v = v + dt * 0.5*(0.04*v*v+5.0*v+140.0-u+i);
	v = v + dt * 0.5*(0.04*v*v+5.0*v+140.0-u+i);
	u = u+ dt * a * (b * v - u);
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	color[U_COLOR] = u / scale;
	color[V_COLOR] = v / scale;
	gl_FragColor = color;
}