// Awful timer by Dima..
// Code can also be used to output such information as resolution or mouse position

// Added vector output function - takes a displays up to 4 components at variable precision 
// inefficient, but very convienient - might draw numbers faster with the box function instead
// use for debugging
// sphinx

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int d_tt = 0x01;
const int d_tr = 0x02;
const int d_tl = 0x04;
const int d_cc = 0x08;
const int d_dr = 0x10;
const int d_dl = 0x20;
const int d_dd = 0x40;
const int d_ff = 0x7F;
int d_v[10];

float line(vec2 p, vec2 a, vec2 b);
float digit(int d, vec2 uv, vec2 p, vec2 s);
float draw (float d, vec2 uv, vec2 p, vec2 s);
vec3 displayVec(vec4 v, vec2 uv, const int c, const int p);
float box(vec2 p, vec2 s);

void main(void) {
    vec2 uv =  gl_FragCoord.xy / resolution.xy;
       
    int components = int(floor(1.+fract(time * .1)* 4.)); 
    int digits   = int(floor(1.+fract(time * .1)* 8.));
    float scale = 10.;
    vec2 position = (uv-mouse-.01) * scale;
    vec4 someValues = vec4(mouse, time*.005, time);
    
    vec3 v = displayVec(someValues,position, components, digits)*.75;

    float b = box(vec2(.01*float(digits), .0265*float(components)), uv-mouse-.008)*.15;
    
    gl_FragColor = vec4(v+b, 0.);
}

float box(vec2 p, vec2 s){
    return float(((p.x > s.x)>(p.y < s.y))&&((p.x < p.x-s.x)<(p.y > p.y-s.y)));
}

float line(vec2 p, vec2 a, vec2 b){
    float d;
	vec2 n, l;
	d = distance(a, b);
	n = normalize(b - a);
	l.x = max(abs(dot(p - a, n.yx * vec2(-1.0, 1.0))), 0.0);
	l.y = max(abs(dot(p - a, n) - d * 0.5) - d * 0.5, 0.0);
	return 1.-step(.015, length(l));
}

float digit(int d, vec2 uv, vec2 p, vec2 s) {
    float n;
	if (d >= d_dd){d -= d_dd; n += line(uv, p,                  p+vec2(s.x,.0));}
	if (d >= d_dl){d -= d_dl; n += line(uv, p,                  p+vec2(.0,s.y*.5));}
	if (d >= d_dr){d -= d_dr; n += line(uv, p+vec2(s.x,.0),     p+vec2(s.x,s.y*.5));}
	if (d >= d_cc){d -= d_cc; n += line(uv, p+vec2(.0,s.y*.5),  p+vec2(s.x,s.y*.5));}
	if (d >= d_tl){d -= d_tl; n += line(uv, p+vec2(.0,s.y*.5),  p+vec2(.0,s.y));}
	if (d >= d_tr){d -= d_tr; n += line(uv, p+vec2(s.x,s.y*.5), p+s);}
	if (d >= d_tt){d -= d_tt; n += line(uv, p+vec2(.0,s.y),     p+s);}
    return n;
}

float draw (float d, vec2 uv, vec2 p, vec2 s) {
    float n;
	if (d < 4.5){
	    if (d < 2.5){
            if (d < 0.5){           
                n += digit(119, uv, p, s); //0
            }else if ( d < 1.5){       
                n += digit(18, uv, p, s);  //1
            }else{                       
                n += digit(107, uv, p, s); //2
            }
        }else if (d < 3.5){         
                n += digit(91, uv, p, s);  //3
            }else{              
                n += digit(30, uv, p, s);  //4
	        }
	    }else{
	        if (d < 7.5) {
                if (d < 5.5){         
                    n += digit(0x5d, uv, p, s); //5
                }else if (d < 6.5){
                    n += digit(125, uv, p, s);  //6
                }else{
                    n += digit( 19, uv, p, s);  //7
                }
       }else if (d < 8.5){
            n += digit(127, uv, p, s);  //8
       }else{               
            n += digit( 95, uv, p, s);  //9
	   }
	}
    return n;
}

vec3 displayVec(vec4 v, vec2 uv, const int c, const int p) {
    vec4 d;
    float n, b;
    vec2 o = vec2(0., -.25+float(c)*.25);
    for (int i = 0; i < 4; i++){
        if(c > i){
            b = 1.e+2;
            for(int j = 0; j < 8; j++){
                if(p > j){
                    n = floor(mod(v[i]*b,10.));
	                d[i] += draw (n, uv, o, vec2(.05, .2));
	                o.x  += .1;
                    b -= 1.e+0;
                }
            }
            o.y -= .25;
            o.x = 0.;
        }
    }   
    return vec3(d.x, d.y, d.z) + d.w;
}
