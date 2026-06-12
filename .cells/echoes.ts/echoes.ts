
// ── define ──────────────────────────────────────
namespace Echoes
{
	export 
	const echoes = 
	<T = {[key: string]: any},> (waves: {[key: string]: (env: T) => any})
	: T => 
		Object.entries(waves).reduce
		(
			(envs, [fn, f]) => ({... envs, [fn]: f(envs)}) ,
			{} as T
		) ;
	
	export 
	const call = 
	<T extends Record<K, (...args: any) => any>, K extends keyof T> 
	(obj: T, key: K): { [P in K]: ReturnType<T[P]>; }[K] => 
		echoes<{[P in K]: ReturnType<T[P]>}>(obj)[key] ;
	
} ;


// ── demo ────────────────────────────────────────
const env_ff = 
{
	f1: (env: { [key: string]: Function }) => 
		
		(n: number): number => 1 + n ,
	
	f2: (env: { [key: string]: Function }) => 
		
		(x: number): number => env.f1(x * 2) ,
	
} ;
// ── effect ──────────────────────────────────────
console.log( Echoes.echoes(env_ff).f2(3) ); //> 7



// ── demo ────────────────────────────────────────
const env_xx = 
{
	x0: (env: { [key: string]: any }) => 
		
		1 ,
	
	f: (env: { [key: string]: any }) => 
		
		(s: string)
		: number => s.length ,
	
	f2: (env: { [key: string]: any }) => 
		
		(s: string, n: number)
		: Promise<number> => Promise.resolve(env.f(s) + n - env.x0) ,
} ;

// ── effect ──────────────────────────────────────
Echoes.echoes<{f2: ReturnType<typeof env_xx.f2>}>(env_xx).f2('a',3).then(r => console.log(r)); //> 3
Echoes.echoes(env_xx).f2('a',3).then( (r: number) => console.log(r) ); //> 3
Echoes.call(env_xx,'f2')('a',3).then(r => console.log(r)); //> 3

