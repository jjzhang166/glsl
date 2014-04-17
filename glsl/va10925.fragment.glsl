#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// From "Random-Access Rendering of General Vector Graphics"
// posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float B1(float t) { return t*t*t; }
float B2(float t) { return 3.0*t*t*(1.0-t); }
float B3(float t) { return 3.0*t*(1.0-t)*(1.0-t); }
float B4(float t) { return (1.0-t)*(1.0-t)*(1.0-t); }

void main(void)
{
	vec2 f = gl_FragCoord.xy/resolution;
	vec2 p[4];
	
	p[0] = vec2(.03,.0);
	p[1] = vec2(.30,.4);
	p[2] = vec2(.60,.6);
	p[2] = vec2(1.0,1.0);
	
	p[0] = vec2(0,.100);
        p[1] = vec2(.50,.200);
        p[2] = vec2(.150,.400);
        p[3] = vec2(.500,.300);
	
	//p[3]=mouse/resolution;
	
	vec2 pos;
	float t = length(f);//mix(0.0,1.0,sin(time));
	pos.x = p[0].x*B1(t) + p[1].x*B2(t) + p[2].x*B3(t) + p[3].x*B4(t);
  	pos.y = p[0].y*B1(t) + p[1].y*B2(t) + p[2].y*B3(t) + p[3].y*B4(t);
	
	
	vec2 pos2;
	t = mix(0.0,1.0,sin(time));;
	pos2.x = p[0].x*B1(t) + p[1].x*B2(t) + p[2].x*B3(t) + p[3].x*B4(t);
  	pos2.y = p[0].y*B1(t) + p[1].y*B2(t) + p[2].y*B3(t) + p[3].y*B4(t);
	
	vec2 d= pos-pos2;
	float g = length(pos);
	//d = f-pos;
	gl_FragColor = vec4(f.x,length(f-pos2)*10.0,0,1.0);
}