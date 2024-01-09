import './NFTPage.css'
import NFTCard from '../NFTCard';

function NFTPage() {
return (
	<div>
        <div className='box horizontal-box'>
            <div className='cards-container'>
                {
                    [...Array(1)].map(() => (
                        <NFTCard contractAddress='' id={1} />))
                }
            </div>
            <div className='box vertical-margin'>
                <div className='box horizontal-box'>
                    <h1 className='title-text'>Auction Site</h1>
                </div>
                <div className='box horizontal-box'>
                    <h1 className='title-text'>Auction Site</h1>
                </div>
            </div>
    	</div>
	</div>
)
}

export default NFTPage;
