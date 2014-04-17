// original authour: mathieu henri aka p01
// ported for glsl.heroku.com by the kevano
// julia is my bitch
// todo list: port animation code and improve resolution
// any help is welcome
// time 01:10 +0000 UTC; date sat the 05th january 2013

uniform lowp float t;


void main( void ) {
	lowp vec4 P=vec4(0,0,-2,0),D=gl_FragCoord/vec4(150,75,1,1)-1.,S=vec4(cos(t),sin(t),cos(t*.9),0)*.8,C=vec4(.4,.6,.7,9),f,T;
	for(int r=0;r<99;r++){T=P;T.w=dot(S,S)/4.;
	lowp float s=D.z=1.,k=dot(T,T);
	for(int m=0;m<7;m++)k<4.?s*=4.*k,f=2.*T.x*T,f.x=2.*T.x*T.x-k,k=dot(T=f+S,T):k;s=sqrt(k/s)*log(k)/4.;P+=D/length(D)*s;
	if(.001>s){C*=log(k);break;}
	}
	gl_FragColor=C+D.y*.4;
}
