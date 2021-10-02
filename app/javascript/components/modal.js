import { Modal } from 'bootstrap'
const autoOpenModal = () => {
  const modal = document.querySelector('.myOpenModal');
  if (modal) {
    new Modal(modal).show()
  }
}
export { autoOpenModal };
