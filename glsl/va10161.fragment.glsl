//Based on http://glsl.heroku.com/e#10127.0
//florian.schindler@aon.at

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;

const int maxIter = 30;

vec2 getPos() {
        vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5);
        pos.x *= resolution.x / resolution.y;
        return pos;
}

float iterate(vec2 p){
	float strength = 7. + 1.5 * sin(time*10.);
	float accum = 0.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 25; ++i) 
	{
		float mag = dot(p, p);
		p = abs(p) / mag - mouse/10. - vec2(0.7,0.6);
		accum += exp(-float(i) / 9. - strength * pow(abs(mag - prev), 20.));
		prev = mag;
	}
	return max(.2, 5. * accum / 10. - .4);
}


void main( void ){
	vec2 cstime = vec2(cos(time/40.),sin(time/40.));
        vec2 c = getPos()*.4+cstime*1.1, c2 = getPos()*.8+cstime+mouse*2.;
        float m;
	
	float col1 = iterate(c), col2 = iterate(c2-.015*vec2(col1,0.));
                
        gl_FragColor = exp(col2) * .2 * vec4(.5,.83,1.,1.);         
}
