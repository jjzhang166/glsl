//Quick and simple escape-time fractal generator
//By florian.schindler@aon.at

//Try playing around with iterate(), checkAbort(), map() and color() functions!

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;

const int maxIter = 100;

vec2 cmult(vec2 a, vec2 b){
        return vec2(a.x*b.x-a.y*b.y,a.x*b.y+a.y*b.x);                
}

float length2(vec2 v){
        return v.x*v.x+v.y*v.y;               
}

vec2 map(vec2 pos){
	return pos;	
	//return vec2(pos.x * sqrt(1.-pos.y*pos.y*2.), pos.y * sqrt(1.-pos.x*pos.x*2.)); //Circle->Square, http://mathproofs.blogspot.co.at/2005/07/mapping-square-to-circle.html
}

vec2 iterate(vec2 p, vec2 c){
	vec2 p2 = cmult(p,p);
	
	//return p2 + c; //Mandelbrot set
        return p2 + vec2(.36,.085); //Julia Set
	//return p-(p2+tan(time*.2))/(p-cos(time*.2));
	//return tan(vec2(p.x+sin(time),p.y+cos(time)))-.52;
	//return tan(p2)-.52;
}

bool checkAbort(vec2 p, vec2 c){	
        return length2(p) > 400.; //Mandelbrot set
	//return length2(p) > 20.; //Julia set
	//return length2(p) > 15100.;
	//return length2(p) > 30.;
	//return length2(p) > 30.;
}

float l2 = log(2.);
vec4 color(int iterations, vec2 p, float trap){
	//float col = (log(float(iterations))-.5) / (log(float(maxIter))+1.);	
	//float col = 1./log(length2(bailout));
	//float col = .75-(float(iterations) - log(log(length2(p)))/l2 )/ float(maxIter);
	float col = (trap*5. + .5*float(iterations)/float(maxIter));
	return vec4(col*1.2,col*1.1,col,1.);
}
//vec4 defaultColor = vec4(1., 0.85, 0.8, 1.);
vec4 defaultColor = vec4(.05,0.025,0., 1.);

const float a = 5., b = 10., c = 0.;
float trapCondition(float trap, in vec2 p){
    //return length(p);
    return abs(a*p.x + b*p.y + c) / sqrt(a*a+b*b);
}

void main( void ){
        vec2 c = map(surfacePosition)*1.+vec2(0.,0);
        vec2 p = c;
        float m, trap = 1e20;
                
        for(int i = 0; i < maxIter ;i++) {
               p = iterate(p,c);
               if(checkAbort(p,c)){        
                       gl_FragColor = color(i,p,trap);
                       return;
               }
		trap = min(trap, trapCondition(trap, p));
        }
                
        gl_FragColor = defaultColor;                
}
